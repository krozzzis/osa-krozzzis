# Extends osa.terminal.wezterm (declared+enabled in the osa flake) with the
# actual look & feel -- same module name, no `options`.
{ delib, ... }:
delib.module {
  name = "osa.terminal.wezterm";

  home.ifEnabled = { myconfig, ... }: {
    programs.wezterm.extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.font = wezterm.font '${myconfig.user.fonts.monospace.name}'
      config.hide_tab_bar_if_only_one_tab = true

      config.colors = {
          background = 'rgba(0,0,0,0.7)',
      }
      return config
    '';
  };
}
