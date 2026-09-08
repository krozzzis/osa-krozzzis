{ delib, ... }:
delib.rice {
  name = "caelestia";
  inherits = [ "all" ];

  myconfig = {
    osa.de.rice.primary = "caelestia";
  };
}
