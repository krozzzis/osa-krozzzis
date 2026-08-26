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
    # home.file появляется только после первого логина, а гритер нужен сразу.
    # Копируем аватар заранее через tmpfiles — работает автоматически при
    # включении модуля, без ручных шагов.
    services.accounts-daemon.enable = true;
    systemd.tmpfiles.rules = [
      "C+ /home/${username}/.face - - - - ${avatar}"
      "d /var/lib/AccountsService/icons 0755 root root -"
      "C+ /var/lib/AccountsService/icons/${username} - - - - ${avatar}"
    ];
  };
}
