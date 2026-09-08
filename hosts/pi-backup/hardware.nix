{ delib, inputs, lib, modulesPath, ... }:
delib.host {
  name = "pi-backup";

  nixos = {
    imports = [
      inputs.nixos-hardware.nixosModules.raspberry-pi-3
      (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    ];

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

    # No LUKS yet — root lives unencrypted on the SD card image.
    # Add disk encryption here later once a keyboard/console-based unlock story exists.
  };
}
