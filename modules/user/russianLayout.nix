{ delib, ... }:
delib.module {
  name = "user.russianLayout";

  options = delib.singleEnableOption true;

  myconfig.ifEnabled.user.input.keyboard.layout = "us,ru";
}
