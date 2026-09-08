{ delib, ... }:
delib.rice {
  name = "xfce";

  myconfig = {
    osa.de.rice.primary = "xfce";
    osa.de.rice.xfce.enable = true;
  };
}
