{ delib, lib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim = {
      # Neovim loads start packages after init.lua. Nixvim generates the
      # colorscheme setup inside init.lua, so load start packages first.
      extraConfigLuaPre = lib.mkBefore ''
        vim.cmd("packloadall")
      '';

      colorschemes.rose-pine = {
        enable = true;

        settings = {
          variant = "main";
          styles.transparency = true;
        };
      };
    };
  };
}
