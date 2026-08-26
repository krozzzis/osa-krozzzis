{ delib, ... }:
delib.rice {
  name = "niri";

  myconfig = {
    user.desktop.enable = true;

    osa.de.niri.enable = true;
    osa.de.dms.enable = true;
    osa.apps.walker.enable = true;
  };

  nixos = {
    services.displayManager.defaultSession = "niri";
  };
}
