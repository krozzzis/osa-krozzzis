{ delib, lib, ... }:
delib.module {
  # Extend OSA's OpenCode setup with personal dark/light theme colors.
  name = "osa.ai.opencode";

  home.ifEnabled = {
    programs.opencode.themes.transparent.theme = lib.mkForce {
      # Dark theme (Kanagawa Gogh) – matching ghostty
      primary = { dark = "#7e9cd8"; light = "#4078f2"; };
      secondary = { dark = "#1f1f28"; light = "#fafafa"; };
      accent = { dark = "#c0a36e"; light = "#c18401"; };
      error = { dark = "#c34043"; light = "#ca1243"; };
      warning = { dark = "#c0a36e"; light = "#c18401"; };
      success = { dark = "#76946a"; light = "#50a14f"; };
      info = { dark = "#7e9cd8"; light = "#0184bc"; };
      text = { dark = "#dcd7ba"; light = "#383a42"; };
      textMuted = { dark = "#727169"; light = "#a0a1a7"; };

      # Keep both modes transparent so the terminal background shows through.
      background = "none";
      backgroundPanel = "none";
      backgroundElement = "none";
      border = "none";
      borderActive = "none";
      borderSubtle = "none";

      diffAdded = { dark = "#76946a"; light = "#50a14f"; };
      diffRemoved = { dark = "#c34043"; light = "#ca1243"; };
      diffContext = { dark = "#727169"; light = "#a0a1a7"; };
      diffHunkHeader = { dark = "#727169"; light = "#a0a1a7"; };
      diffAddedBg = "none";
      diffRemovedBg = "none";
      diffContextBg = "none";
      diffHighlightAdded = { dark = "#76946a"; light = "#50a14f"; };
      diffHighlightRemoved = { dark = "#c34043"; light = "#ca1243"; };
      diffLineNumber = { dark = "#727169"; light = "#a0a1a7"; };
      diffAddedLineNumberBg = "none";
      diffRemovedLineNumberBg = "none";

      markdownText = { dark = "#dcd7ba"; light = "#383a42"; };
      markdownHeading = { dark = "#ebbcba"; light = "#4078f2"; };
      markdownLink = { dark = "#c4a7e7"; light = "#4078f2"; };
      markdownLinkText = { dark = "#9ccfd8"; light = "#0184bc"; };
      markdownCode = { dark = "#76946a"; light = "#50a14f"; };
      markdownBlockQuote = { dark = "#727169"; light = "#a0a1a7"; };
      markdownEmph = { dark = "#c34043"; light = "#ca1243"; };
      markdownStrong = { dark = "#c0a36e"; light = "#c18401"; };
      markdownHorizontalRule = { dark = "#727169"; light = "#a0a1a7"; };
      markdownListItem = { dark = "#ebbcba"; light = "#4078f2"; };
      markdownListEnumeration = { dark = "#c4a7e7"; light = "#a626a4"; };
      markdownImage = { dark = "#9ccfd8"; light = "#0184bc"; };
      markdownImageText = { dark = "#9ccfd8"; light = "#0184bc"; };
      markdownCodeBlock = { dark = "#dcd7ba"; light = "#383a42"; };

      syntaxComment = { dark = "#727169"; light = "#a0a1a7"; };
      syntaxKeyword = { dark = "#c4a7e7"; light = "#a626a4"; };
      syntaxFunction = { dark = "#ebbcba"; light = "#4078f2"; };
      syntaxVariable = { dark = "#dcd7ba"; light = "#383a42"; };
      syntaxString = { dark = "#76946a"; light = "#50a14f"; };
      syntaxNumber = { dark = "#c0a36e"; light = "#986801"; };
      syntaxType = { dark = "#9ccfd8"; light = "#0184bc"; };
      syntaxOperator = { dark = "#ebbcba"; light = "#4078f2"; };
      syntaxPunctuation = { dark = "#c4a7e7"; light = "#383a42"; };
    };
  };
}
