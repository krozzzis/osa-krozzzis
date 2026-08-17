{ delib, lib, ... }:

delib.module {
  name = "user.shell";

  options = { myconfig, ... }: {
    user.shell.enable = delib.description (delib.boolOption false) "Enable shell utilities (fish, eza, yazi, vim, etc.)";
    user.shell.default = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrs);
      default = null;
      description = "Default shell module (set to myconfig.osa.shell.zsh or myconfig.osa.shell.fish in host)";
    };
  };

  home.ifEnabled = {
    home.sessionPath = [ "$HOME/.cargo/bin" ];
  };

  nixos.always = { myconfig, ... }: let
    inherit (myconfig.user.constants) username;
  in {
    users.users.${username}.shell = lib.mkIf (myconfig.user.shell.default != null)
      myconfig.user.shell.default.pkg;
  };
}
