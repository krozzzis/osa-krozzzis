{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim.diagnostic.settings = {
      virtual_text = false;
      virtual_lines.current_line = true;
      signs = true;
      underline = true;
      severity_sort = true;
      update_in_insert = false;
    };

    programs.nixvim = {
      opts = {
        number = true;
        relativenumber = true;
        tabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        smartindent = true;
        wrap = true;
        langmap = "йцукенгшщзхъфывапролджэячсмитьбю;qwertyuiop[]asdfghjkl'zxcvbnm\\,./,ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;QWERTYUIOP{}ASDFGHJKL\"ZXCVBNM<>?";
        termguicolors = true;
        mouse = "a";
        clipboard = "unnamedplus";
      };

      globals = {
        mapleader = " ";
      };
    };
  };
}
