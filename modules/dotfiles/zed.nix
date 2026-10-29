{ delib, ... }:
delib.module {
  name = "osa.editor.zed";

  home.ifEnabled = {
    programs.zed-editor = {
      extensions = [
        "kanagawa-themes"
        "rose-pine-theme"
      ];
      userSettings.theme = {
        mode = "system";
        light = "One Light";
        dark = "Rosé Pine";
      };
    };
  };
}
