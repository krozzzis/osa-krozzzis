{ delib, ... }:
delib.rice {
  name = "driftwm";
  # Keep the complete Niri+DMS session installed as a fallback.
  inherits = [ "niri" ];

  myconfig = {
    osa.de.rice.primary = "driftwm";
    osa.de.rice.driftwm.enable = true;
  };
}
