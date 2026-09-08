{ delib, ... }:
delib.module {
  name = "user.capsLockSwitchLayout";

  options = delib.singleEnableOption true;

  myconfig.ifEnabled.user.input.keyboard.options = "grp:caps_toggle";
}
