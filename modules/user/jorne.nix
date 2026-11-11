{ delib, ... }:
delib.module {
  name = "user.jorne";

  nixos.always =
    { myconfig, ... }:
    let
      inherit (myconfig.user.constants) username;
    in
    {
      users.groups.plugdev = { };
      users.users.${username}.extraGroups = [ "plugdev" ];

      # Vial uses raw HID; dialout only covers the Caterina serial bootloader.
      services.udev.extraRules = ''
        SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ATTRS{idVendor}=="4753", ATTRS{idProduct}=="0001", GROUP="plugdev", MODE="0660", TAG+="uaccess"
      '';
    };
}
