{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled.programs.nixvim.plugins.yazi = {
    enable = true;
    lazyLoad.enable = true;
    lazyLoad.settings.cmd = [ "Yazi" ];
    settings = {
      open_for_directories = false;
      open_multiple_tabs = true;
      use_ya_for_events_reading = true;
    };
  };
}
