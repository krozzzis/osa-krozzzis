{ delib, ... }:
delib.rice {
  name = "all";
  inheritanceOnly = true;

  # Install every compositor+shell bundle; selectable denix rices below only
  # choose which one is primary.
  myconfig = {
    osa.de.rice.niri.enable = true;
    osa.de.rice.caelestia.enable = true;
    osa.de.rice.xfce.enable = true;
  };
}
