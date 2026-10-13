{ delib, lib, ... }:

delib.module {
  name = "user.desktop";

  options = { myconfig, ... }: {
    user.desktop.enable = delib.description (delib.boolOption false) "Enable desktop/PC mode (meta-option enabling gui and shell)";
  };

  myconfig.ifEnabled = { myconfig, ... }: {
    user = {
      gui.enable = true;
      ui.transparency = 0.95;
      ui.workspaces = map toString (lib.range 0 9);
      shell = {
        enable = true;
        default = lib.mkDefault myconfig.osa.shell.fish;
      };
      editor.default = lib.mkDefault myconfig.osa.editor.nixvim;
      browser.default = lib.mkDefault myconfig.osa.browser.zenBrowser;
      taskManager.default = lib.mkDefault myconfig.osa.taskManager.missionCenter;
      fileManager.default = lib.mkDefault myconfig.osa.fileManager.nautilus;
      imageViewer.default = lib.mkDefault myconfig.osa.apps.loupe;
      pdfViewer.default = lib.mkDefault myconfig.osa.apps.papers;
      musicPlayer.default = lib.mkDefault myconfig.osa.media.cloudmus;
      videoPlayer.default = lib.mkDefault myconfig.osa.media.vlc;
    };

    osa = {
      taskManager.missionCenter.enable = true;
      apps.foliate.enable = true;
      fileManager.dolphin.enable = false;
      fileManager.flux.enable = false;
      system.ntfs.enable = false;
      media = {
        cloudmus.enable = true;
        cloudmus.notifications = "SILENT";
        musescore.enable = true;
        lspPlugins.enable = true;
        kdenlive.enable = true;
      };
    };
  };
}
