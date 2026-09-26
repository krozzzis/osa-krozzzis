{
  delib,
  lib,
  pkgs,
  inputs,
  ...
}:
delib.host {
  name = "nixlaptop";

  rice = "niri";

  myconfig = { myconfig, ... }: {
    # The denix rice now only chooses the primary OSA rice/session.
    user.desktop.enable = true;

    osa.editor.nixvim.enable = true;
    osa.browser.zenBrowser.enable = true;
    osa.browser.firefox.enable = true;
    osa.browser.chromium.enable = true;
    osa.browser.librewolf.enable = false;
    user.browser.default = lib.mkForce myconfig.osa.browser.zenBrowser;
    osa.media.reaper.enable = false;
    osa.media.patchbay.enable = false;
    osa.terminal.wezterm.enable = true;
    osa.apps.wireshark.enable = true;
    osa.apps.loupe.enable = true;
    osa.apps.wine = {
      enable = true;
      profiles.wine-ru = {
        prefix = ".wine-ru";
        locale = "ru_RU.UTF-8";
      };
    };
    osa.apps.qpwgraph.enable = false;
    osa.apps.cosmic.enable = false;
    osa.apps.arduinoIde.enable = false;
    osa.apps.obsidian.enable = true;
    osa.shell.fzf.enable = true;
    osa.shell.fastfetch.enable = true;

    osa.system.libvirtd.enable = true;
    osa.system.audio.enable = true;
    osa.system.printing.enable = true;

    osa.system.hibernate.enable = true;
    osa.system.hibernate.resumeDevice = "/dev/mapper/cryptroot";
    osa.system.hibernate.resumeOffset = 533760;

    osa.system.plymouth.enable = true;
    osa.system.plymouth.theme = "material";
  };

  home.home.stateVersion = "26.05";
  home.home.packages = [
    inputs."lyrics-visualizer".packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  nixos.system.stateVersion = "26.05";

  nixos = {
    # Fix zen-browser ffmpeg_7 -> ffmpeg_8 after nixpkgs c043 removed ffmpeg_7
    nixpkgs.overlays = [
      (final: prev: {
        ffmpeg_7 = prev.ffmpeg_8 or prev.ffmpeg;
      })
    ];

    zramSwap.enable = true;
    time.timeZone = "Asia/Yekaterinburg";
    i18n.extraLocales = [ "ru_RU.UTF-8/UTF-8" ];

    swapDevices = [ { device = "/swap/swapfile"; } ];
    boot.kernelParams = [
      # Lucienne's s2idle resume hangs (frozen screen right after lid-open).
      # PSR (Panel Self Refresh) is the usual culprit on AMD iGPU laptops;
      # this bit disables it.
      "amdgpu.dcdebugmask=0x10"
    ];

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;

    environment.systemPackages = [ pkgs.python3 ];

    boot.tmp.useTmpfs = true;

    # Lets `nix build` cross-compile aarch64 hosts (e.g. pi-backup) via QEMU emulation.
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    # Root is LUKS+btrfs (see disko.nix); ZFS is unused here but its default
    # inclusion drags in a separate out-of-tree kernel module build.
    boot.supportedFilesystems.zfs = false;
  };
}
