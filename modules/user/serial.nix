{ delib, ... }:
delib.module {
  name = "user.serial";

  nixos.always =
    { myconfig, ... }:
    let
      inherit (myconfig.user.constants) username;
    in
    {
      # Serial adapters (FTDI/CP210x/CH34x/CDC-ACM) must be usable without
      # sudo. `dialout` covers sessions without a seat (ssh), `uaccess`
      # grants the locally logged-in user access via systemd-logind ACLs.
      users.users.${username}.extraGroups = [ "dialout" ];

      services.udev.extraRules = ''
        SUBSYSTEM=="tty", KERNEL=="ttyUSB[0-9]*", GROUP="dialout", MODE="0660", TAG+="uaccess"
        SUBSYSTEM=="tty", KERNEL=="ttyACM[0-9]*", GROUP="dialout", MODE="0660", TAG+="uaccess"
      '';
    };
}
