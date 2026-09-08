{ delib, ... }:
delib.host {
  name = "eeepc";

  nixos = {
    boot.initrd.systemd.enable = true;

    boot.loader = {
      # This machine's Phoenix BIOS (2010, ASUS Eee PC 1001PXD) has no UEFI,
      # so grub goes on the BIOS-boot (EF02) partition from disko.nix
      # instead of nixlaptop's systemd-boot/EFI setup.
      grub = {
        enable = true;
        efiSupport = false;
        # devices is left unset — disko.nix's EF02 partition already
        # configures boot.loader.grub.devices from the disk it lives on.
      };
      timeout = 3;
    };

    # No plymouth — a boot splash isn't worth the extra RAM/CPU here.
    boot.consoleLogLevel = 3;
    boot.initrd.verbose = false;
    boot.kernelParams = [ "quiet" "udev.log_level=3" ];
  };
}
