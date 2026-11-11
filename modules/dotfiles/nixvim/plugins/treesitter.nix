{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim.plugins.treesitter = {
      enable = true;

        highlight = {
          enable = true;
          disable.__raw = ''
            function(_, buf)
              local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
              return stat and stat.size > 1024 * 1024 or false
            end
          '';
        };
        indent = {
          enable = true;
          disable.__raw = ''
            function(_, buf)
              local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
              return stat and stat.size > 1024 * 1024 or false
            end
          '';
        };
      settings = {
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
