# Extends osa.terminal.wezterm (declared+enabled in the osa flake) with the
# personal appearance-aware color schemes.
{ delib, ... }:
delib.module {
  name = "osa.terminal.wezterm";

  home.ifEnabled = { myconfig, ... }: {
    programs.wezterm.extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.color_scheme = wezterm.gui.get_appearance():find 'Dark'
        and 'Kanagawa (Gogh)' or 'One Light (base16)'

      config.font = wezterm.font '${myconfig.user.fonts.monospace.name}'
      config.hide_tab_bar_if_only_one_tab = true

      return config
    '';
  };
}
