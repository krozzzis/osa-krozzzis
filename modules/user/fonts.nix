{ delib, lib, pkgs, ... }:
delib.module {
  name = "user.fonts";

  options = { myconfig, ... }: {
    user.fonts.enable = delib.boolOption true;
  };

  nixos.ifEnabled = { myconfig, ... }: {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      liberation_ttf

      twemoji-color-font

      inter
      jetbrains-mono
    ] ++ lib.optionals myconfig.user.gui.fonts.nerdfonts [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];

    fonts.fontconfig = {
      defaultFonts = {
        serif     = [ "Noto Serif" "Noto Serif CJK SC" ];
        sansSerif = [ "Inter" "Noto Sans CJK SC" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK SC" ];
        emoji     = [ "Twemoji Mozilla" "Noto Color Emoji" ];
      };
    };
  };
}
