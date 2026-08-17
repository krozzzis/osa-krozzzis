{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim.plugins.mini = {
      enable = true;

      modules = {
        indentscope = {
          symbol = "│";
          draw = {
            animation.__raw = "require('mini.indentscope').gen_animation.none()";
          };
        };
        basics = { };
        comment = { };
        pairs = { };
        ai = { };
        statusline = { };
      };
    };
  };
}
