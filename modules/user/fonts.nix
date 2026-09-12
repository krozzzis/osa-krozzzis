{
  delib,
  lib,
  pkgs,
  ...
}:
let
  uiFontSize = 11;
in
delib.module {
  name = "user.fonts";

  options = { myconfig, ... }: {
    user.fonts.enable = delib.boolOption true;
  };

  # These handles are the single source of truth for system and application fonts.
  myconfig.always = {
    user.fonts.regular = {
      pkg = pkgs.inter;
      name = "Inter";
    };
    user.fonts.monospace = {
      pkg = pkgs.jetbrains-mono;
      name = "JetBrains Mono";
    };
  };

  nixos.ifEnabled = { myconfig, ... }: {
    fonts.packages =
      with pkgs;
      [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        liberation_ttf
        twemoji-color-font
        myconfig.user.fonts.regular.pkg
        myconfig.user.fonts.monospace.pkg
      ]
      ++ lib.optionals myconfig.user.gui.fonts.nerdfonts [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
      ];

    fonts.fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
        ];
        sansSerif = [
          myconfig.user.fonts.regular.name
          "Noto Sans CJK SC"
        ];
        monospace = [
          (
            if myconfig.user.gui.fonts.nerdfonts then
              "JetBrainsMono Nerd Font"
            else
              myconfig.user.fonts.monospace.name
          )
          "Noto Sans Mono CJK SC"
        ];
        emoji = [
          "Twemoji Mozilla"
          "Noto Color Emoji"
        ];
      };
    };
  };

  home.ifEnabled = { myconfig, ... }: {
    # Configure toolkits as well as fontconfig so GUI applications agree.
    gtk = {
      enable = true;
      font = {
        name = myconfig.user.fonts.regular.name;
        size = uiFontSize;
      };
      iconTheme = {
        package = lib.mkForce myconfig.user.ui.iconTheme.pkg;
        name = lib.mkForce myconfig.user.ui.iconTheme.name;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };

    # Niri uses the KDE Qt platform theme, so set every KDE/Qt UI font role
    # explicitly instead of falling back to Qt's default 12-point font.
    xdg.configFile."kdeglobals".text =
      let
        font = "${myconfig.user.fonts.regular.name},${toString uiFontSize},-1,5,50,0,0,0,0,0";
        fixedFont = "${myconfig.user.fonts.monospace.name},${toString uiFontSize},-1,5,50,0,0,0,0,0";
      in
      ''
        [General]
        fixed=${fixedFont}
        font=${font}
        menuFont=${font}
        smallestReadableFont=${font}
        toolBarFont=${font}

        [WM]
        activeFont=${font}
      '';

    home.packages = with pkgs; [
      myconfig.user.fonts.regular.pkg
      myconfig.user.fonts.monospace.pkg
    ];
  };
}
