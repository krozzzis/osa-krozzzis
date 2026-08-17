{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "user.home";

  home.always =
    { myconfig, ... }:
    let
      inherit (myconfig.user.constants) username;
    in
    {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
      };
    };

  nixos.always = {
    home-manager.backupFileExtension = ".bak";
  };
}
