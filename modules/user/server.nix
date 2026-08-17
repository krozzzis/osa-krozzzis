{ delib, lib, ... }:

delib.module {
  name = "user.server";

  options = {
    user.server.enable = delib.description (delib.boolOption false) "Enable server mode";
  };

  myconfig.ifEnabled = { ... }: {
    user.shell.enable = true;
  };

  nixos.ifEnabled = {
    services.openssh.enable = true;

    # Servers are expected to be accessed via authorized keys, configured
    # per-host. Password auth stays off so a server never sits on the
    # network reachable with just a guessed password.
    services.openssh.settings.PasswordAuthentication = false;
    services.openssh.settings.PermitRootLogin = "no";
  };
}
