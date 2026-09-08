{ delib, lib, pkgs, ... }:
delib.host {
  name = "eeepc";

  rice = "niri";

  myconfig = { myconfig, ... }: {
    user.desktop.enable = true;

    user.shell.default = myconfig.osa.shell.fish;
    user.editor.default = myconfig.osa.editor.vim;
    user.terminal.default = myconfig.osa.terminal.wezterm;
    user.browser.default = myconfig.osa.browser.zenBrowser;
    user.fileManager.default = myconfig.osa.fileManager.nautilus;
    user.imageViewer.default = myconfig.osa.apps.swayimg;
    user.pdfViewer.default = { pkg = pkgs.zathura; };
    user.musicPlayer.default = { pkg = pkgs.mpv; };
    user.videoPlayer.default = { pkg = pkgs.mpv; };

    osa.shell.fzf.enable = true;

    # Most osa.* app/media/browser/AI modules default to
    # `user.gui.enable`, i.e. they install themselves the moment desktop
    # mode is on. Trim what's not needed here: no AI coding assistants,
    # no office suite, no VM/Windows-interop tooling, no other browsers
    # than zen-browser (set as the default above).
    osa.browser.firefox.enable = false;
    osa.browser.librewolf.enable = false;
    osa.browser.tor.enable = false;

    osa.editor.zed.enable = false;

    osa.media.vlc.enable = false;
    osa.media.reaper.enable = false;
    osa.media.audacity.enable = false;
    osa.media.obs.enable = false;
    osa.media.qbittorrent.enable = false;

    osa.office.libreoffice.enable = false;

    osa.apps.wireshark.enable = false;
    osa.apps.arduinoIde.enable = false;
    osa.apps.qpwgraph.enable = false;
    osa.apps.gparted.enable = false;
    osa.apps.kdeconnect.enable = false;
    osa.apps.prismlauncher.enable = false;
    osa.apps.rpiImager.enable = false;
    osa.apps.telegram.enable = false;
    osa.apps.android.enable = false;
    osa.apps.virtManager.enable = false;
    osa.apps.winapps.enable = false;
    osa.apps.throne.enable = false;

    osa.ai.claude-code.enable = false;
    osa.ai.opencode.enable = false;

    # optimize.nix assumes systemd-boot + btrfs (nixlaptop's setup); eeepc
    # boots via grub + ext4 (see boot.nix/disko.nix).
    osa.system.optimize.enable = false;

    # audio.nix forces jack/qjackctl and pins the CPU governor to
    # "performance" for pro-audio latency, which is wrong for a netbook
    # that just wants to play back music/video. Plain pipewire below covers
    # that instead.
    osa.system.audio.enable = false;

    osa.system.libvirtd.enable = false;
  };

  home.home.stateVersion = "26.05";
  nixos.system.stateVersion = "26.05";

  home = {
    manual.manpages.enable = false;
    manual.json.enable = false;
    manual.html.enable = false;
  };

  nixos = {
    zramSwap.enable = true;
    time.timeZone = "Asia/Yekaterinburg";

    documentation.enable = false;
    documentation.nixos.enable = false;
    documentation.man.enable = lib.mkForce false;
    documentation.doc.enable = false;

    powerManagement.enable = true;
    services.power-profiles-daemon.enable = true;

    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    # Root is plain ext4 (see disko.nix); ZFS is unused here but its default
    # inclusion drags in a separate out-of-tree kernel module build — a real
    # cost on this machine's weak Atom N455.
    boot.supportedFilesystems.zfs = false;
  };
}
