{
  delib,
  inputs,
  lib,
  ...
}:
delib.host {
  name = "pi-backup";

  myconfig = { ... }: {
    user.server.enable = true;

    # osa.system.optimize assumes systemd-boot + btrfs (nixlaptop's setup).
    # pi-backup boots via extlinux and currently has a plain ext4 root, so skip it.
    osa.system.optimize.enable = false;

    # These write keyboard-layout settings into programs.niri.settings even
    # without a GUI, which pulls the whole niri package into the build just
    # to validate the generated config. Meaningless on a headless server.
    user.capsLockSwitchLayout.enable = false;
    user.russianLayout.enable = false;
  };

  home.home.stateVersion = "26.05";

  nixos = { myconfig, ... }: {
    system.stateVersion = "26.05";
    time.timeZone = "Asia/Yekaterinburg";

    # No password login at all (see modules/user/server.nix -- password
    # auth is off and this account has no password hash either); SSH key
    # only.
    users.users.${myconfig.user.constants.username}.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3JM/W76cJjAW/1QflJsfrFrL9UuVR5UGmnyhjbIycY schumov.nn@gmail.com"
    ];

    # RPi 3B has 1GB RAM and no swap configured at all otherwise; zram gives
    # cheap headroom for backup workloads (restic/borg compression, activation)
    # without wearing the SD card the way a swap file would.
    zramSwap.enable = true;

    # /boot lives on the small FAT partition from sd-image-aarch64.nix.
    # nix.gc (osa.system.autoClean) only prunes the Nix store, not old
    # extlinux boot entries, so cap those separately to keep that partition
    # from filling up over months of generations.
    boot.loader.generic-extlinux-compatible.configurationLimit = 5;

    # Unbounded journald on an SD card is a slow-motion full-disk problem on
    # a box nobody is watching.
    services.journald.extraConfig = "SystemMaxUse=200M";

    # RPi 3's bcm2835 watchdog hardware caps out well under a minute, so keep
    # the timeout short; this just forces a reboot if the box wedges instead
    # of staying dark until someone notices.
    boot.kernelModules = [ "bcm2835_wdt" ];
    systemd.settings.Manager = {
      RuntimeWatchdogSec = "10s";
      RebootWatchdogSec = "10s";
    };

    # Root is plain ext4 (see hardware.nix); ZFS is unused here but its
    # default inclusion drags in a separate out-of-tree kernel module build
    # (zfs-kernel) on every rebuild. Dropping it removes a full compile from
    # the critical path.
    boot.supportedFilesystems.zfs = false;

    # nixlaptop builds this aarch64 host by running the vendor kernel's own
    # aarch64 gcc under QEMU user-mode emulation (see nixlaptop's
    # boot.binfmt.emulatedSystems) -- every compiler invocation pays a heavy
    # per-instruction emulation tax. pkgsCross.aarch64-multiplatform instead
    # cross-compiles with a native x86_64 gcc that merely *targets* aarch64,
    # which is dramatically faster. It only changes this one derivation --
    # the rest of the system keeps using cache.nixos.org's native aarch64
    # builds exactly as before.
    #
    # SOUND, MEDIA_SUPPORT (camera/TV/DVB) and BT are unused on this headless,
    # ethernet-only backup box and together account for a large share of the
    # vendor defconfig's compiled modules. SOUND is deliberately left alone:
    # vc4's HDMI driver (DRM_VC4, required by initrd and the HDMI console
    # fallback) depends on the ALSA core and silently drops out of the built
    # kernel if SOUND=no -- confirmed via `kernel.configfile`, not by testing
    # on the actual hardware.
    boot.kernelPackages =
      let
        cross = inputs.nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;
        rpiKernel = cross.callPackage "${inputs.nixos-hardware}/raspberry-pi/common/kernel.nix" {
          rpiVersion = 3;
        };
        kernel = rpiKernel.override (old: {
          argsOverride = (old.argsOverride or { }) // {
            structuredExtraConfig = rpiKernel.structuredExtraConfig // {
              MEDIA_SUPPORT = lib.kernel.no;
              BT = lib.kernel.no;
            };
          };
        });
      in
      lib.mkForce (cross.linuxPackagesFor kernel);
  };
}
