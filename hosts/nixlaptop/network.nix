{ delib, ... }:
delib.host {
  name = "nixlaptop";

  nixos = {
    networking.hostName = "nixlaptop";
    networking.networkmanager.enable = true;
    networking.wireless.enable = true;
  };
}
