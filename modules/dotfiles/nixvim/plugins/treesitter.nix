{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim.plugins.treesitter = {
      enable = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;
        ensureInstalled = [
          "rust"
          "python"
          "nix"
          "toml"
          "json"
          "yaml"
          "lua"
          "vim"
          "vimdoc"
          "bash"
          "markdown"
          "markdown_inline"
        ];
      };
    };
  };
}
