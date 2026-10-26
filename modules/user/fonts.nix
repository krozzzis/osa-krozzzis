{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "user.fonts";

  myconfig.always = { myconfig, ... }: {
    user.fonts.regular = {
      pkg = pkgs.inter;
      name = "Inter";
    };
    user.fonts.monospace = {
      disabledLigatures = [ "***" ];
      pkg = import ../../packages/jetbrains-mono-custom {
        inherit pkgs;
        inherit (myconfig.user.fonts.monospace) disabledLigatures;
      };
      name = "JetBrains Mono";
    };
    user.ui.fontSize = 11;
  };
}
