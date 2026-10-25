{ delib, config, ... }:
delib.host {
  name = "nixlaptop";

  nixos = {
    services.scx = {
      enable = true;
      # Use the existing unstable application package set, independently of
      # stable NixOS. This exact package is available in the binary caches.
      package = config.myconfig.osa.nixpkgs.packages.unstable.scx.rustscheds;
      scheduler = "scx_lavd";
      extraArgs = [
        # Follow PPD/DMS profiles, including the laptop's AC/battery policy.
        "--autopower"
        # Leave AMD P-state/EPP frequency management to PPD.
        "--no-freq-scaling"
      ];
    };

    systemd.services.scx.after = [
      "power-profiles-daemon.service"
      "laptop-power-profile.service"
    ];
  };
}
