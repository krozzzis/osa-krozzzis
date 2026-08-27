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

      -- background/opacity now handled in osa.terminal.wezterm (window_background_opacity 0.95, wayland blur, #0a0a0a)
      -- keep only font/hide_tab_bar here, don't override colors/background
      return config
    '';
  };
}
