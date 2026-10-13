{
  delib,
  inputs,
  lib,
  ...
}:
delib.module {
  name = "user.zenBrowser";

  options = {
    user.zenBrowser.enable = delib.description (delib.boolOption false) "Enable personal Zen Browser settings";
  };

  myconfig.ifEnabled = { myconfig, ... }: {
    osa.browser.zenBrowser = {
      enable = true;
      pkg =
        let
          zenPkgs = myconfig.osa.nixpkgs.packages.${myconfig.osa.browser.zenBrowser.nixpkgs};
          zen = import inputs.zen-browser { pkgs = zenPkgs; };
          wrapZen = import (inputs.zen-browser + "/wrap-zen.nix") zenPkgs.wrapFirefox;
        in
        wrapZen (zen.beta-unwrapped.override {
          policies.Preferences = {
            "dom.webgpu.enabled" = {
              Value = true;
              Status = "locked";
            };
            "zen.theme.content-element-separation" = {
              Value = 0;
              Status = "locked";
            };
            "zen.view.experimental-no-window-controls" = {
              Value = true;
              Status = "locked";
            };
          };
        }) {
          icon = "zen-browser";
        };
    };

    user.browser.default = lib.mkForce myconfig.osa.browser.zenBrowser;
  };

}
