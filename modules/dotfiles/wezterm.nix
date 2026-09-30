# Extends osa.terminal.wezterm (declared+enabled in the osa flake) with the
# actual look & feel -- same module name, no `options`.
{ delib, ... }:
delib.module {
  name = "osa.terminal.wezterm";

  home.ifEnabled = { myconfig, ... }: {
    programs.wezterm.extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      local theme_path = wezterm.home_dir .. '/.config/wezterm/colors/dank-theme.toml'
      wezterm.add_to_config_reload_watch_list(theme_path)

      local loaded, theme = pcall(wezterm.color.load_scheme, theme_path)
      if loaded and theme and theme.background then
        config.colors = { background = theme.background }
      end

      config.font = wezterm.font '${myconfig.user.fonts.monospace.name}'
      config.hide_tab_bar_if_only_one_tab = true

      return config
    '';
  };
}
