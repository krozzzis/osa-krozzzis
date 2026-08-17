{ delib, ... }:
delib.rice {
  name = "hyprland";

  myconfig = {
    osa.de.hyprland.enable = true;
    osa.apps.polkitLxqtAgent.enable = true;
    osa.system.sddm.enable = true;
  };

  nixos = {
    services.displayManager.defaultSession = "hyprland";
  };
}
