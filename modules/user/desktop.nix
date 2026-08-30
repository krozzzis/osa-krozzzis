{ delib, lib, ... }:

delib.module {
  name = "user.desktop";

  options = { myconfig, ... }: {
    user.desktop.enable = delib.description (delib.boolOption false) "Enable desktop/PC mode (meta-option enabling gui and shell)";
  };

  myconfig.ifEnabled = { myconfig, ... }: {
    user.gui.enable = true;
    user.shell.enable = true;

    osa.system.ntfs.enable = false;

    # Music notation + audio plugins (LV2/VST3/CLAP exposed via vstPath).
    osa.media.musescore.enable = true;
    osa.media.lspPlugins.enable = true;
    osa.media.kdenlive.enable = true;

    # Default apps — user preferences, not host hardware.
    # mkDefault so a host (e.g. eeepc) can still override per-device if needed.
    user.shell.default = lib.mkDefault myconfig.osa.shell.fish;
    user.editor.default = lib.mkDefault myconfig.osa.editor.nixvim;
    user.browser.default = lib.mkDefault myconfig.osa.browser.zenBrowser;
    user.fileManager.default = lib.mkDefault myconfig.osa.fileManager.nautilus;
    user.imageViewer.default = lib.mkDefault myconfig.osa.apps.swayimg;
    user.pdfViewer.default = lib.mkDefault myconfig.osa.apps.cosmic.reader;
    user.musicPlayer.default = lib.mkDefault myconfig.osa.media.vlc;
    user.videoPlayer.default = lib.mkDefault myconfig.osa.media.vlc;
  };
}
