{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim.plugins.indent-blankline = {
      enable = true;
      settings.indent.char = "│";
    };

    programs.nixvim.plugins.mini = {
      enable = true;

      modules = {
        basics = { };
        comment = { };
        pairs = { };
        ai = { };
        statusline = { };
      };
    };
  };
}
