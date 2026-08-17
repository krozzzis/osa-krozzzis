{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim.colorschemes.rose-pine = {
      enable = true;

      settings = {
        variant = "main";
        styles.transparency = true;
      };
    };
  };
}
