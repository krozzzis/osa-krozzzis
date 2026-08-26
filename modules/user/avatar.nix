{ delib, lib, ... }:
delib.module {
  name = "user.avatar";

  options = { myconfig, ... }: {
    osa.user.avatar = lib.mkOption {
      type = lib.types.path;
      default = ./assets/avatar.png;
      description = "Path to the user's avatar image. Applied to the account icon, the login manager (SDDM/greetd) and the lock screen wherever a face is expected.";
    };
  };

  home.always = { myconfig, ... }: {
    # Display managers and lock screens look these up in the user's home:
    #  - .face.icon  : SDDM
    #  - .face       : GDM / AccountsService fallback / dms greeter
    #  - .face.png   : backwards-compatible name some tools still read
    home.file = {
      ".face".source = myconfig.osa.user.avatar;
      ".face.icon".source = myconfig.osa.user.avatar;
      ".face.png".source = myconfig.osa.user.avatar;
    };
  };

  nixos.always = { myconfig, ... }: let
    inherit (myconfig.user.constants) username;
    avatar = myconfig.osa.user.avatar;
  in {
    # home.file runs only after the first login (home-manager activation),
    # so at the very first greeter the files don't exist yet. Seed them
    # early via tmpfiles so AccountsService (which serves them over D-Bus
    # because the greeter can't read 0700 ~) has something to show.
    services.accounts-daemon.enable = true;

    systemd.tmpfiles.rules = [
      "d /home/${username} 0700 ${username} users -"
      "C+ /home/${username}/.face - - - - ${avatar}"
      "C+ /home/${username}/.face.icon - - - - ${avatar}"
      "C+ /home/${username}/.face.png - - - - ${avatar}"
      "z /home/${username}/.face 0644 ${username} users -"
      "z /home/${username}/.face.icon 0644 ${username} users -"
      "z /home/${username}/.face.png 0644 ${username} users -"
      # AccountsService also looks under /var/lib/AccountsService
      "d /var/lib/AccountsService/icons 0755 root root - -"
      "C+ /var/lib/AccountsService/icons/${username} - - - - ${avatar}"
    ];
  };
}
