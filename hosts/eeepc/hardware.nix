{ delib, config, lib, modulesPath, ... }:
delib.host {
  name = "eeepc";

  # The N455 in this netbook (Pineview, 2010) supports x86_64 despite the
  # machine originally shipping 32-bit software, and x86_64-linux has full
  # binary-cache coverage in nixpkgs, unlike i686-linux (which would mean
  # compiling systemd/Python/GHC/etc. from source for a huge, multi-hour+
  # first build).
  system = "x86_64-linux";

  nixos = {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    # Common controllers for this era of Atom netbook (SATA/PATA disk, USB2
    # ports/installer stick). Adjust after running the real
    # `nixos-generate-config` on the machine if something doesn't match.
    boot.initrd.availableKernelModules = [ "ahci" "ata_piix" "sd_mod" "ehci_pci" "uhci_hcd" "usb_storage" "sdhci_pci" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    # fileSystems and swapDevices are declared in disko.nix.
    # Do NOT add them here — disko generates them automatically.

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # GMA 3150 (Pineview IGP on the N455) is driven by the in-kernel i915
    # driver — no extra Xorg driver package or out-of-tree kernel module
    # needed, unlike the older GMA 500/Poulsbo chips (gma500_gfx).
  };
}
