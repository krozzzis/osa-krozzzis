{ delib, ... }:
delib.rice {
  name = "xfce";

  myconfig = {
    osa.de.xfce.enable = true;
  };

  nixos = {
    services.displayManager.defaultSession = "xfce";
  };
}
