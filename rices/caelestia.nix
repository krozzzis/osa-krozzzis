{ delib, ... }:
delib.rice {
  name = "caelestia";

  myconfig = {
    osa.de.hyprland.enable = true;
    osa.de.caelestia.enable = true;
    osa.apps.polkitLxqtAgent.enable = true;
    osa.system.sddm.enable = true;
  };

  nixos = {
    services.displayManager.defaultSession = "hyprland";
  };
}
