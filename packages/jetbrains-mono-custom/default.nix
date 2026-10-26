{ pkgs, disabledLigatures ? [ "***" ] }:

pkgs.jetbrains-mono.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
    (pkgs.python3.withPackages (pythonPackages: [
      pythonPackages.brotli
      pythonPackages.fonttools
    ]))
  ];

  postInstall = (old.postInstall or "") + ''
    python3 ${./remove-ligatures.py} \
      --sequences ${pkgs.lib.escapeShellArg (builtins.toJSON disabledLigatures)} \
      "$out/share/fonts"
  '';
})
