{ delib, ... }:
delib.module {
  name = "user.packageChannels";
  myconfig.always = { myconfig, ... }: {
    osa = {
      system.nixpkgs = "stable";
      nixpkgs.default = "unstable";

      # Large applications with little benefit from following every rebuild
      # of unstable. Keep plugins and their host in the same package set.
      apps.rustdesk = {
        enable = myconfig.user.gui.enable;
        nixpkgs = "stable";
      };
      apps.wine.nixpkgs = "unstable";
      apps.arduinoIde.nixpkgs = "stable";
      office.libreoffice.nixpkgs = "stable";
      media = {
        kdenlive.nixpkgs = "stable";
        obs.nixpkgs = "stable";
        musescore.nixpkgs = "stable";
        audacity.nixpkgs = "unstable";
        lspPlugins.nixpkgs = "stable";
        patchbay.nixpkgs = "stable";
      };
      editor.zed.nixpkgs = "unstable";
      editor.nixvim.nixpkgs = "unstable";
      browser.zenBrowser.nixpkgs = "unstable";
      de.dms.nixpkgs = "unstable";
      de.dms.quickshell.nixpkgs = "unstable";
    };
  };
}
