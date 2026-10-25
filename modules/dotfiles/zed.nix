{ delib, ... }:
delib.module {
  name = "osa.editor.zed";

  home.ifEnabled = {
    programs.zed-editor = {
      extensions = [ "kanagawa-themes" ];
      userSettings.theme = {
        mode = "system";
        light = "Kanagawa Lotus";
        dark = "Kanagawa Wave";
      };
    };
  };
}
