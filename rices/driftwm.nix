{ delib, ... }:
delib.rice {
  name = "driftwm";
  inherits = [ "all" ];

  myconfig = {
    osa.de.rice.primary = "driftwm";
  };
}
