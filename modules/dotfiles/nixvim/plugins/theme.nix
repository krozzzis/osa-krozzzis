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
        local function desktop_background()
          local handle = io.popen(
            "timeout 1s gdbus call --session " ..
            "--dest org.freedesktop.portal.Desktop " ..
            "--object-path /org/freedesktop/portal/desktop " ..
            "--method org.freedesktop.portal.Settings.Read " ..
            "org.freedesktop.appearance color-scheme 2>/dev/null"
          )
          if not handle then return "dark" end
          local response = handle:read("*a")
          handle:close()
          local scheme = response:match("uint32%s+(%d+)")
          if scheme == "2" then return "light" end
          if scheme == "1" then return "dark" end
          return vim.o.background
        end

        local function apply_theme()
          local background = desktop_background()
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
      '';

      extraConfigLuaPost = ''
        apply_theme()

        -- Re-read the desktop preference whenever Neovim regains focus.
        vim.api.nvim_create_autocmd("FocusGained", {
          callback = function()
            if desktop_background() ~= vim.o.background then
              apply_theme()
            end
          end,
        })
      '';

      extraPlugins = [ pkgs.vimPlugins.base16-vim pkgs.vimPlugins.kanagawa-nvim ];
    };
  };
}
