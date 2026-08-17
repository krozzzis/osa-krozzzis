{ delib, ... }:
delib.module {
  name = "user.account";

  nixos.always =
    { myconfig, ... }:
    let
      inherit (myconfig.user.constants) username;
    in
    {
      users = {
        groups.${username} = { };

        users.${username} = {
          isNormalUser = true;
          initialPassword = username;
          extraGroups = [ "wheel" "networkmanager" "kvm" "adbusers" ];
        };
      };
    };
}
