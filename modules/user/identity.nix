# Values only -- the user.* option declarations live in the osa flake
# (modules/osa/user/default.nix); downstream flakes just fill them in.
{ delib, ... }:
delib.module {
  name = "user.constants";

  myconfig.always = {
    user.constants = {
      username = "krozzzis";
      useremail = "schumov.nn@gmail.com";
    };
  };
}
