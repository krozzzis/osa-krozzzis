{ delib, ... }:
delib.rice {
  name = "caelestia";

  myconfig = {
    osa.de.rice.primary = "caelestia";
    osa.de.rice.caelestia.enable = true;
  };
}
