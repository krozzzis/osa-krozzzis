{ delib, lib, pkgs, ... }:
delib.module {
  name = "user.fonts";

  options = { myconfig, ... }: {
    user.fonts.enable = delib.boolOption true;
  };

  # Устанавливаем глобальные шрифты как просили: Inter + JetBrains Mono
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
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      liberation_ttf
      twemoji-color-font
      myconfig.user.fonts.regular.pkg
      myconfig.user.fonts.monospace.pkg
    ] ++ lib.optionals myconfig.user.gui.fonts.nerdfonts [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];

    fonts.fontconfig = {
      defaultFonts = {
        serif     = [ "Noto Serif" "Noto Serif CJK SC" ];
        sansSerif = [ myconfig.user.fonts.regular.name "Noto Sans CJK SC" ];
        monospace = [
          (if myconfig.user.gui.fonts.nerdfonts then "JetBrainsMono Nerd Font" else myconfig.user.fonts.monospace.name)
          "Noto Sans Mono CJK SC"
        ];
        emoji     = [ "Twemoji Mozilla" "Noto Color Emoji" ];
      };
    };
  };

  home.ifEnabled = { myconfig, ... }: {
    # GTK / Qt — чтобы все приложения брали тот же шрифт, а не только fontconfig
    gtk = {
      enable = true;
      font = {
        name = myconfig.user.fonts.regular.name;
        size = 11;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };

    home.packages = with pkgs; [
      myconfig.user.fonts.regular.pkg
      myconfig.user.fonts.monospace.pkg
    ];
  };
}
