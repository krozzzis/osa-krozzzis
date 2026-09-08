{ delib, ... }:
delib.host {
  name = "eeepc";

  nixos = {
    networking.hostName = "eeepc";
    networking.networkmanager.enable = true;
    networking.wireless.enable = true;
  };
}
