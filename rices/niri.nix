{ delib, ... }:
delib.rice {
  name = "niri";
  inherits = [ "all" ];

  myconfig = {
    osa.de.rice.primary = "niri";
  };
}
