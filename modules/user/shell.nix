{
  delib,
  lib,
  pkgs,
  ...
}:

# Behavior only -- user.shell.* option declarations live in the osa flake.
delib.module {
  name = "user.shell";

  home.ifEnabled = {
    home.sessionPath = [ "$HOME/.cargo/bin" ];
  };

  nixos.always =
    { myconfig, ... }:
    let
      inherit (myconfig.user.constants) username;
    in
    {
      users.users.${username}.shell = lib.mkIf (
        myconfig.user.shell.default != null
      ) myconfig.user.shell.default.pkg;
    };
}
