{ delib, lib, pkgs, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim = {
      # Both colorschemes are installed; the desktop appearance decides which
      # one is applied, so Nixvim must not set a default colorscheme itself.
      colorscheme = null;

      # Nixvim emits colorscheme setup into init.lua, so load start packages
      # first. The selected colorscheme is applied in extraConfigLuaPost,
      # after both plugin setups have run.
      extraPackages = [ pkgs.glib.bin pkgs.coreutils ];

      extraConfigLuaPre = lib.mkBefore ''
        vim.cmd("packloadall")

        -- Rosé Pine for dark, One Light for light.
        local function apply_theme(background)
          vim.o.background = background
          if background == "light" then
            vim.cmd.colorscheme("base16-one-light")
          else
            require("kanagawa").setup({
              theme = "wave",
              transparent = true,
            })
            vim.cmd.colorscheme("kanagawa")
          end
          -- Keep the terminal's selected background visible through every
          -- window, including the end-of-buffer area and floating windows.
          for _, group in ipairs({ "Normal", "NormalNC", "EndOfBuffer", "SignColumn", "FoldColumn", "NormalFloat", "FloatBorder" }) do
            vim.api.nvim_set_hl(0, group, { bg = "none" })
          end
        end

        local function update_theme()
          vim.system({ "gdbus", "call", "--session",
            "--dest", "org.freedesktop.portal.Desktop",
            "--object-path", "/org/freedesktop/portal/desktop",
            "--method", "org.freedesktop.portal.Settings.Read",
            "org.freedesktop.appearance", "color-scheme" }, { text = true, timeout = 1000 }, function(result)
              local scheme = (result.stdout or ""):match("uint32%s+(%d+)")
              local background = scheme == "2" and "light" or scheme == "1" and "dark" or nil
              if background then
                vim.schedule(function()
                  if background ~= vim.o.background then apply_theme(background) end
                end)
              end
            end)
        end
      '';

      extraConfigLuaPost = ''
        apply_theme(vim.o.background)
        update_theme()

        -- Re-read the desktop preference whenever Neovim regains focus.
        vim.api.nvim_create_autocmd("FocusGained", {
          callback = update_theme,
        })
      '';

      extraPlugins = [ pkgs.vimPlugins.base16-vim pkgs.vimPlugins.kanagawa-nvim ];
    };
  };
}
