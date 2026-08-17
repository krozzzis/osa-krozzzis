{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim = {
      opts = {
        number = true;
        relativenumber = true;
        tabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        smartindent = true;
        wrap = false;
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
