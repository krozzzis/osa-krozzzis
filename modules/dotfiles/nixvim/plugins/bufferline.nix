{ delib, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled.programs.nixvim.plugins.bufferline.enable = true;
}
