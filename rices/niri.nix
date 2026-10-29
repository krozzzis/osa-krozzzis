{ delib, lib, inputs, ... }:
delib.rice {
  name = "niri";

  myconfig = lib.recursiveUpdate {
    osa.de.rice.niri.enable = true;
    osa.de.niri.shakeToFind.enable = true;
  } (lib.optionalAttrs (builtins.pathExists (inputs.osa.outPath + "/modules/osa/apps/file-roller.nix")) {
    # Allow write-flake to run against the locked OSA before the module is published.
    osa.apps.fileRoller.enable = true;
  });
}
