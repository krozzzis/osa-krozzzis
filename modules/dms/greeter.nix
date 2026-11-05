{ delib, inputs, lib, ... }:
delib.module {
  name = "osa.de.dms.greeter";
  nixos.always.imports = [ inputs.dank-greeter.nixosModules.default ];
  nixos.ifEnabled = { myconfig, ... }: {
    services.displayManager.dms-greeter.enable = lib.mkForce false;
    programs.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      quickshell.package = myconfig.osa.de.dms.quickshell.pkg;
      configHome = "/home/${myconfig.user.constants.username}";
    };
  };
}
