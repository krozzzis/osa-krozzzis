{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled.programs.nixvim.plugins.telescope = {
    enable = true;
    lazyLoad.enable = true;
    lazyLoad.settings.cmd = [ "Telescope" ];
  };
}
