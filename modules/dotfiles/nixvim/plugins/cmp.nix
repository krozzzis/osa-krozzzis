{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim.plugins.blink-cmp = {
      enable = true;

      settings = {
        keymap = {
          preset = "default";

          "<C-y>" = {
            action = "select_and_accept";
          };
          "<C-e>" = {
            action = "hide";
          };
        };

        sources = {
          default = [
            "lsp"
            "path"
            "buffer"
          ];
        };
      };
    };
  };
}
