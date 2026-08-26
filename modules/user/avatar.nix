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

  nixos.always = {
    # Стандартный путь NixOS: аватар из home.file + AccountsService для гритера.
    # Без tmpfiles-хаков — иконка появится после первого логина (home-manager
    # создаст ~/.face), на первом экране гритера будет дефолтная.
    services.accounts-daemon.enable = true;
  };
}
