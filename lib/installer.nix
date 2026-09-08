# Turns any generated `nixosConfigurations.<name>` (which must import
# disko and target x86_64-linux/i686-linux) into a standalone, fully
# offline installer ISO for that exact host+rice combination.
#
# Deliberately built as a *plain* `nixpkgs.lib.nixosSystem`, bypassing
# denix/delib entirely — the installer must not inherit the target's own
# myconfig (that would rebuild the whole target desktop as the live
# environment's own active config, and re-trigger every osa.* module
# default meant for a desktop host, e.g. niri/audio/sudo-rs).
#
# Deliberately does NOT shell out to disko's own `disko-install`: that tool
# re-evaluates the whole target flake on the machine being installed to
# (via `extendModules`, to substitute the user-supplied disk device into
# `disko.devices`), which is redundant here — every host in this repo
# already hardcodes its disk device in `hosts/*/disko.nix`, so
# `target.config.system.build.{toplevel,diskoScript}` (evaluated once,
# on the dev machine building this ISO) are already exactly what
# disko-install would re-derive. On weak/low-RAM install targets (e.g.
# eeepc's 2010 Atom netbook) that redundant on-device eval was slow
# enough to look hung. The install script below runs the pre-built
# diskoScript and nixos-install directly instead.
{ inputs }:
{
  targetName,
  target,
}:
let
  lib = inputs.nixpkgs.lib;
  pkgs = target.pkgs;

  diskName = builtins.head (builtins.attrNames target.config.disko.devices.disk);
  diskDevice = target.config.disko.devices.disk.${diskName}.device;

  # Besides the target's toplevel, nixos-install needs diskoScript and a
  # couple of perl modules its own machinery shells out to.
  #
  # Deliberately NOT included: any .drvPath (upstream disko-install's own
  # example adds stdenv.drvPath, diskoScript.drvPath, and closureInfo's
  # own .drvPath). A .drv's closure is its *build-time* dependency graph,
  # which for anything built with the standard stdenv reaches all the way
  # back to nixpkgs' bootstrap seeds (multiple gcc stages, binutils,
  # cmake, clang, the M0/M1/M2 bootstrap chain) — tens of GB, and only
  # relevant if something needed to be *rebuilt* from source. We're
  # installing the exact toplevel already built for this ISO, so nothing
  # should need rebuilding; if that assumption ever breaks, the fix is to
  # add back the specific .drvPath that's missing, not all of them
  # pre-emptively.
  dependencies = [
    target.config.system.build.toplevel
    target.config.system.build.diskoScript
    pkgs.perlPackages.ConfigIniFiles
    pkgs.perlPackages.FileSlurp
  ];

  closureInfo = pkgs.closureInfo { rootPaths = dependencies; };
in
lib.nixosSystem {
  system = target.config.nixpkgs.hostPlatform.system;
  modules = [
    (
      { pkgs, modulesPath, ... }:
      {
        imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

        networking.hostName = "${targetName}-installer";
        system.stateVersion = target.config.system.stateVersion;

        # Cheap safety net for weak/low-RAM install targets (e.g. eeepc's
        # 1GB Atom netbook): the live squashfs+tmpfs environment has no
        # disk swap available until diskoScript formats the target disk,
        # so give it compressed RAM-backed swap in the meantime.
        zramSwap.enable = true;

        # Pulling this into environment.etc makes closureInfo (and
        # everything it was computed from — the target's whole closure)
        # a dependency of this installer's own system.build.toplevel, so
        # isoImage's squashfs (which already bundles system.build.toplevel's
        # closure) picks it all up without needing to list it in
        # isoImage.storeContents by hand.
        environment.etc."install-closure".source = "${closureInfo}/store-paths";
        environment.etc."install-registration".source = "${closureInfo}/registration";

        environment.systemPackages = [
          pkgs.xcp
          (pkgs.writeShellScriptBin "osa-install" ''
            set -euo pipefail
            if [ "$#" -ne 1 ]; then
              echo "Usage: osa-install <disk-device>  (e.g. osa-install ${diskDevice})" >&2
              exit 1
            fi
            if [ "$1" != "${diskDevice}" ]; then
              echo "error: this image was built for ${diskDevice} (see hosts/${targetName}/disko.nix), not $1" >&2
              exit 1
            fi
            # The live installer's "nixos" user has passwordless sudo, so
            # just re-exec through it instead of making the user type
            # sudo themselves.
            if [ "$(id -u)" -ne 0 ]; then
              exec sudo "$0" "$@"
            fi

            root=/mnt

            # DISKO_SKIP_SWAP: format the swap partition but don't swapon
            # it here — swapping to the disk we're about to install onto,
            # from the live session, is asking for trouble. The installed
            # system swaps on to it itself at first boot via fstab.
            DISKO_SKIP_SWAP=1 ${target.config.system.build.diskoScript}

            echo "Copying store paths..." >&2
            mkdir -p "$root/nix/store"
            xargs xcp --recursive --target-directory "$root/nix/store" < /etc/install-closure
            echo "Loading nix database..." >&2
            NIX_STATE_DIR="$root/nix/var/nix" nix-store --load-db < /etc/install-registration

            exec nixos-install --no-channel-copy --no-root-password \
              --system ${target.config.system.build.toplevel} --root "$root"
          '')
        ];
      }
    )
  ];
}
