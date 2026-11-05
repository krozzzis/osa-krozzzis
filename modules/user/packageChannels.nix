{ delib, inputs, ... }:
delib.module {
  name = "user.packageChannels";
  myconfig.always = { myconfig, ... }: {
    osa = {
      system.nixpkgs = "stable";
      nixpkgs.default = "unstable";

      # The locked OSA revision applies a patch incompatible with Ghostty 1.4.
      # Use the selected channel package until the OSA lock is updated.
      terminal.ghostty.pkg =
        myconfig.osa.nixpkgs.packages.${myconfig.osa.terminal.ghostty.nixpkgs}.ghostty;

      # Set false to restore upstream WezTerm notification behavior.
      terminal.wezterm.notifications.autoExpire = false;

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
      ai.codex.nixpkgs = "unstable";
      # Freeze the installed, patched build; updating nixpkgs must not rebuild it.
      ai.codex.pkg = myconfig.osa.nixpkgs.packages.${myconfig.osa.ai.codex.nixpkgs}.runCommand
        "codex-0.165.0-pinned"
        { meta.mainProgram = "codex"; }
        ''ln -s ${inputs.codex-build} "$out"'';
      editor.zed.nixpkgs = "unstable";
      editor.nixvim.nixpkgs = "unstable";
      browser.zenBrowser.nixpkgs = "unstable";
      de.dms.nixpkgs = "unstable";
      de.dms.quickshell.nixpkgs = "unstable";
    };
  };
}
