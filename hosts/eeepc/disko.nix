{ delib, inputs, ... }:
delib.host {
  name = "eeepc";

  nixos = {
    imports = [ inputs.disko.nixosModules.disko ];

    # Change this to match the actual disk device.
    # Run `lsblk` to find it (usually /dev/sda for this era of netbook).
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              # BIOS-boot partition for grub — this machine has no UEFI.
              boot = {
                size = "1M";
                type = "EF02";
              };

              root = {
                end = "-2G";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  mountOptions = [ "noatime" ];
                };
              };

              # A small disk-backed swap on top of zramSwap (see
              # default.nix): with only ~1GB of RAM, zram alone can still
              # get squeezed under real memory pressure, and this is a
              # cheap backstop against OOM kills.
              swap = {
                size = "100%";
                content = {
                  type = "swap";
                  discardPolicy = "both";
                };
              };
            };
          };
        };
      };
    };
  };
}
