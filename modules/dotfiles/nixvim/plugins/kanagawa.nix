{ delib, lib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim = {
      # Kanagawa selects Lotus or Wave from 'background'. Read the desktop
      # preference on startup and refresh it whenever Neovim regains focus.
      extraConfigLuaPre = lib.mkBefore ''
        -- Nixvim emits colorscheme setup in init.lua, so load start packages first.
        vim.cmd("packloadall")
        local function sync_background()
          local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
          if not handle then return end
          local scheme = handle:read("*a")
          handle:close()
          vim.o.background = scheme:match("prefer%-light") and "light" or "dark"
        end
        sync_background()
      '';

      extraConfigLuaPost = ''
        vim.api.nvim_create_autocmd("FocusGained", {
          callback = function()
            local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
            if not handle then return end
            local scheme = handle:read("*a")
            handle:close()
            local background = scheme:match("prefer%-light") and "light" or "dark"
            if vim.o.background ~= background then
              vim.o.background = background
              vim.cmd.colorscheme("kanagawa")
            end
          end,
        })
      '';

      colorschemes.kanagawa = {
        enable = true;
        settings = {
          transparent = true;
        };
      };
    };
  };
}
