{ delib, ... }:
delib.rice {
  name = "xfce";
  inherits = [ "all" ];

  myconfig = {
    osa.de.rice.primary = "xfce";
  };
}
