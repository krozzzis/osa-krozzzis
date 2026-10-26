# JetBrains Mono with configurable ligatures

This package starts from the selected nixpkgs `jetbrains-mono` package and
removes only the requested character-sequence ligatures. It supports direct
OpenType ligature substitutions and JetBrains Mono's contextual ligatures.
The patch applies to installed TTF, OTF, and WOFF2 files.

Set `user.fonts.monospace.disabledLigatures` in `modules/user/fonts.nix`:

```nix
user.fonts.monospace.disabledLigatures = [
  "***"
  "==="
  "<*"
];
```

The selected list is passed to the package builder, which patches the shared
monospace font used by terminals and other configured applications.
