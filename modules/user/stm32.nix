{ delib, ... }:
delib.module {
  name = "user.stm32";

  myconfig.always = { myconfig, ... }: {
    osa.apps.stm32cubeide.enable = myconfig.user.desktop.enable;
    osa.apps.stm32cubemx.enable = myconfig.user.desktop.enable;
  };
}
