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
            require("onedark").setup({ style = "light", transparent = true })
          else
            require("rose-pine").setup({
              variant = "main",
              styles = { transparency = true },
            })
          end
          vim.cmd.colorscheme(background == "light" and "onedark" or "rose-pine")
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

      colorschemes.onedark = {
        enable = true;
        settings = {
          style = "light";
          transparent = true;
        };
      };

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
