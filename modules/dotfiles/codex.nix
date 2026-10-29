{ delib, ... }:
delib.module {
  name = "osa.ai.codex";

  myconfig.ifEnabled = { ... }: {
    # Use the terminal's live ANSI palette for code and diff highlighting.
    osa.ai.codex.settings.tui.theme = "ansi";
  };
}
