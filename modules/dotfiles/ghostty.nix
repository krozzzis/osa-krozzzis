# Match the appearance-aware terminal themes used by WezTerm.
#
# Ghostty's built-in names are not the same palettes: "Atom One Light" is an
# iTerm2/Gogh conversion whose bright colors duplicate the normal ones (bright
# cyan is plain green, bright yellow a pale tan), which makes the whole light
# theme look washed out next to WezTerm, and Ghostty ships no "Kanagawa" theme
# at all (only Kanagawa Wave/Dragon/Lotus), so the dark half silently fell back
# to Ghostty's default colors. Define WezTerm's exact schemes instead.
{ delib, pkgs, ... }:
delib.module {
  name = "osa.terminal.ghostty";

  home.ifEnabled = { ... }: {
    programs.ghostty = {
      # WezTerm "One Light (base16)" (purpleKarrot/base16-one-light-scheme).
      themes.one-light = {
        palette = [
          "0=#fafafa"
          "1=#ca1243"
          "2=#50a14f"
          "3=#c18401"
          "4=#4078f2"
          "5=#a626a4"
          "6=#0184bc"
          "7=#383a42"
          "8=#a0a1a7"
          "9=#ca1243"
          "10=#50a14f"
          "11=#c18401"
          "12=#4078f2"
          "13=#a626a4"
          "14=#0184bc"
          "15=#090a0b"
          "16=#d75f00"
          "17=#986801"
          "18=#f0f0f1"
          "19=#e5e5e6"
          "20=#696c77"
          "21=#202227"
        ];
        background = "#fafafa";
        foreground = "#383a42";
        cursor-color = "cell-foreground";
        cursor-text = "cell-background";
        selection-background = "#383a42";
        selection-foreground = "#fafafa";
      };

      # WezTerm "Kanagawa (Gogh)".
      themes.kanagawa-gogh = {
        palette = [
          "0=#090618"
          "1=#c34043"
          "2=#76946a"
          "3=#c0a36e"
          "4=#7e9cd8"
          "5=#957fb8"
          "6=#6a9589"
          "7=#dcd7ba"
          "8=#727169"
          "9=#e82424"
          "10=#98bb6c"
          "11=#e6c384"
          "12=#7fb4ca"
          "13=#938aa9"
          "14=#7aa89f"
          "15=#c8c093"
        ];
        background = "#1f1f28";
        foreground = "#dcd7ba";
        cursor-color = "cell-foreground";
        cursor-text = "cell-background";
      };

      settings = {
        theme = "dark:kanagawa-gogh,light:one-light";
        "app-notifications" = "no-config-reload";
        custom-shader = "${pkgs.fetchurl {
          name = "ghostty-cursor-tail.glsl";
          url = "https://raw.githubusercontent.com/sahaj-b/cursor-shaders/9ad9158a93c0de0c045e1c6b27df37da698bc8af/ghostty/cursor_tail.glsl";
          hash = "sha256-CEEjiRG9USeW8i9c+FbFgt8Rzcrc11KFNHOfvH0soxI=";
        }}";
        working-directory = "home";
        window-inherit-working-directory = false;
        tab-inherit-working-directory = false;
        split-inherit-working-directory = false;

        # Keep the caret the thin bar Fish asks for at the prompt, but make it
        # wide enough to find at a glance. Default bar width is 1px and the
        # modifier is a delta in pixels.
        cursor-style = "bar";
        adjust-cursor-thickness = 1;
      };
    };
  };
}
