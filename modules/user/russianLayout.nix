{ delib, ... }:
delib.module {
  name = "user.russianLayout";

  options = delib.singleEnableOption true;

  nixos.ifEnabled = {
    services.xserver.xkb.layout = "us,ru";
  };

  myconfig.ifEnabled.osa.de.driftwm.settings.input.keyboard.layout = "us,ru";

  home.ifEnabled.programs.niri.settings.input.keyboard.xkb.layout = "us,ru";
}
