{ delib, lib, pkgs, ... }:

delib.module {
  name = "user.gui";

  options = { myconfig, ... }: {
    user.gui.enable = delib.description (delib.boolOption false) "Enable GUI mode";
    user.gui.fonts.nerdfonts = delib.description (delib.boolOption false) "Enable Nerd Fonts for icons in terminal and GUI";
  };

}
