{ delib, lib, ... }:
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
      extraConfigLuaPre = lib.mkBefore ''
        vim.cmd("packloadall")

        -- Kanagawa Dragon for dark, Rosé Pine Dawn for light.
        local function desktop_background()
          local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
          if not handle then return "dark" end
          local scheme = handle:read("*a")
          handle:close()
          return scheme:match("prefer%-light") and "light" or "dark"
        end

        local function apply_theme()
          local background = desktop_background()
          vim.o.background = background
          vim.cmd.colorscheme(background == "light" and "rose-pine" or "kanagawa")
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

      colorschemes.kanagawa = {
        enable = true;
        settings = {
          background.dark = "dragon";
          transparent = true;
        };
      };

      colorschemes.rose-pine = {
        enable = true;
        settings = {
          variant = "dawn";
          styles.transparency = true;
        };
      };
    };
  };
}
