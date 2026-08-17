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
  };
}
