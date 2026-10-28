# Extends osa.terminal.ghostty with the same appearance-aware Kanagawa
# palettes used by WezTerm.
{ delib, ... }:
delib.module {
  name = "osa.terminal.ghostty";

  home.ifEnabled = { ... }: {
    programs.ghostty.settings.theme = "dark:Kanagawa,light:Kanagawa Lotus";
  };
}
