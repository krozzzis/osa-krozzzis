{ delib, lib, ... }:
delib.module {
  # Extend OSA's OpenCode setup with personal dark/light theme colors.
  name = "osa.ai.opencode";

  home.ifEnabled = {
    programs.opencode.themes.transparent.theme = lib.mkForce {
      primary = { dark = "#ebbcba"; light = "#4078f2"; };
      secondary = { dark = "#f6c177"; light = "#0184bc"; };
      accent = { dark = "#c4a7e7"; light = "#a626a4"; };
      error = { dark = "#eb6f92"; light = "#e45649"; };
      warning = { dark = "#f6c177"; light = "#c18401"; };
      success = { dark = "#31748f"; light = "#50a14f"; };
      info = { dark = "#9ccfd8"; light = "#0184bc"; };
      text = { dark = "#e0def4"; light = "#383a42"; };
      textMuted = { dark = "#908caa"; light = "#a0a1a7"; };

      # Keep both modes transparent so the terminal background shows through.
      background = "none";
      backgroundPanel = "none";
      backgroundElement = "none";
      border = "none";
      borderActive = "none";
      borderSubtle = "none";

      diffAdded = { dark = "#31748f"; light = "#50a14f"; };
      diffRemoved = { dark = "#eb6f92"; light = "#e45649"; };
      diffContext = { dark = "#908caa"; light = "#a0a1a7"; };
      diffHunkHeader = { dark = "#908caa"; light = "#a0a1a7"; };
      diffAddedBg = "none";
      diffRemovedBg = "none";
      diffContextBg = "none";
      diffHighlightAdded = { dark = "#31748f"; light = "#50a14f"; };
      diffHighlightRemoved = { dark = "#eb6f92"; light = "#e45649"; };
      diffLineNumber = { dark = "#908caa"; light = "#a0a1a7"; };
      diffAddedLineNumberBg = "none";
      diffRemovedLineNumberBg = "none";

      markdownText = { dark = "#e0def4"; light = "#383a42"; };
      markdownHeading = { dark = "#ebbcba"; light = "#4078f2"; };
      markdownLink = { dark = "#c4a7e7"; light = "#4078f2"; };
      markdownLinkText = { dark = "#9ccfd8"; light = "#0184bc"; };
      markdownCode = { dark = "#31748f"; light = "#50a14f"; };
      markdownBlockQuote = { dark = "#908caa"; light = "#a0a1a7"; };
      markdownEmph = { dark = "#eb6f92"; light = "#e45649"; };
      markdownStrong = { dark = "#f6c177"; light = "#c18401"; };
      markdownHorizontalRule = { dark = "#908caa"; light = "#a0a1a7"; };
      markdownListItem = { dark = "#ebbcba"; light = "#4078f2"; };
      markdownListEnumeration = { dark = "#c4a7e7"; light = "#a626a4"; };
      markdownImage = { dark = "#9ccfd8"; light = "#0184bc"; };
      markdownImageText = { dark = "#9ccfd8"; light = "#0184bc"; };
      markdownCodeBlock = { dark = "#e0def4"; light = "#383a42"; };

      syntaxComment = { dark = "#908caa"; light = "#a0a1a7"; };
      syntaxKeyword = { dark = "#c4a7e7"; light = "#a626a4"; };
      syntaxFunction = { dark = "#ebbcba"; light = "#4078f2"; };
      syntaxVariable = { dark = "#e0def4"; light = "#383a42"; };
      syntaxString = { dark = "#31748f"; light = "#50a14f"; };
      syntaxNumber = { dark = "#f6c177"; light = "#986801"; };
      syntaxType = { dark = "#9ccfd8"; light = "#0184bc"; };
      syntaxOperator = { dark = "#ebbcba"; light = "#4078f2"; };
      syntaxPunctuation = { dark = "#c4a7e7"; light = "#383a42"; };
    };
  };
}
