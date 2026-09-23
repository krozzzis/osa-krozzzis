{ delib, ... }:
delib.rice {
  name = "all";

  # Install every compositor+shell bundle and keep Niri as the default session.
  myconfig = {
    osa.de.rice.primary = "niri";
    osa.de.rice.niri.enable = true;
    osa.de.rice.driftwm.enable = true;
    osa.de.rice.xfce.enable = true;
  };
}
