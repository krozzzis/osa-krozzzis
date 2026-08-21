{ delib, lib, ... }:

delib.module {
  name = "user.desktop";

  options = { myconfig, ... }: {
    user.desktop.enable = delib.description (delib.boolOption false) "Enable desktop/PC mode (meta-option enabling gui and shell)";
  };

  myconfig.ifEnabled = { ... }: {
    user.gui.enable = true;
    user.shell.enable = true;

    osa.system.ntfs.enable = false;

    # Music notation + audio plugins (LV2/VST3/CLAP exposed via vstPath).
    osa.media.musescore.enable = true;
    osa.media.lspPlugins.enable = true;
  };
}
