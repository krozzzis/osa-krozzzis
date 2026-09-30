{ delib, ... }:
delib.rice {
  name = "niri";

  myconfig = {
    osa.de.rice.niri.enable = true;
    osa.de.niri.shakeToFind.enable = true;
  };
}
