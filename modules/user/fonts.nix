{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "user.fonts";

  myconfig.always = {
    user.fonts.regular = {
      pkg = pkgs.inter;
      name = "Inter";
    };
    user.fonts.monospace = {
      pkg = pkgs.jetbrains-mono;
      name = "JetBrains Mono";
    };
    user.ui.fontSize = 11;
  };
}
