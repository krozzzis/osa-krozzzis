{ delib, lib, ... }:
delib.host {
  name = "pi-backup";

  nixos = {
    networking.hostName = "pi-backup";
    networking.useDHCP = lib.mkDefault true;
  };
}
