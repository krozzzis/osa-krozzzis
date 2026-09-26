{ delib, lib, ... }:

delib.module {
  name = "user.desktop";

  options = { myconfig, ... }: {
    user.desktop.enable = delib.description (delib.boolOption false) "Enable desktop/PC mode (meta-option enabling gui and shell)";
  };

  myconfig.ifEnabled = { myconfig, ... }: {
    user = {
      gui.enable = true;
      ui.workspaces = map toString (lib.range 0 9);
      shell = {
        enable = true;
        default = lib.mkDefault myconfig.osa.shell.fish;
      };
      editor.default = lib.mkDefault myconfig.osa.editor.nixvim;
      browser.default = lib.mkDefault myconfig.osa.browser.zenBrowser;
      fileManager.default = lib.mkDefault myconfig.osa.fileManager.nautilus;
      imageViewer.default = lib.mkDefault myconfig.osa.apps.loupe;
      pdfViewer.default = lib.mkDefault myconfig.osa.apps.papers;
      musicPlayer.default = lib.mkDefault myconfig.osa.media.vlc;
      videoPlayer.default = lib.mkDefault myconfig.osa.media.vlc;
    };

    osa = {
      system.ntfs.enable = false;
      media = {
        musescore.enable = true;
        lspPlugins.enable = true;
        kdenlive.enable = true;
      };
    };
  };
}
