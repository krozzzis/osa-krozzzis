{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim.plugins.mini = {
      enable = true;

      modules = {
        basics = { };
        comment = { };
        pairs = { };
        ai = { };
        statusline = { };
        surround = { };
        move = { };
        trailspace = { };
        diff = { };
        git = { };
      };
    };

  };
}
