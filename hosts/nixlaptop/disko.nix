{ delib, inputs, ... }:
delib.host {
  name = "nixlaptop";

  nixos = {
    imports = [ inputs.disko.nixosModules.disko ];

    # Change this to match your actual disk device.
    # Run `lsblk` to find it (usually /dev/nvme0n1 or /dev/sda).
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "fmask=0077" "dmask=0077" ];
                };
              };

              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptroot";
                  extraFormatArgs = [ "--label" "disk" ];
                  settings = {
                    # Allow TRIM on SSD through LUKS.
                    # Safe on modern drives; omit if HDD.
                    allowDiscards = true;
                    bypassWorkqueues = true;
                  };
                  # TPM2/FIDO2 can be added here later via extraFormatArgs / extraOpenArgs
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-L" "nixos" "-f" ];
                    subvolumes = {
                      # Root — wiped on each nixos-rebuild if you add impermanence later
                      "@" = {
                        mountpoint = "/";
                        mountOptions = [ "compress=zstd:3" "noatime" ];
                      };
                      # Home on a separate subvolume for easy snapshotting
                      "@home" = {
                        mountpoint = "/home";
                        mountOptions = [ "compress=zstd:3" "noatime" ];
                      };
                      # Nix store — huge, benefits from compression
                      "@nix" = {
                        mountpoint = "/nix";
                        mountOptions = [ "compress=zstd:3" "noatime" ];
                      };
                      # Persistent state (logs, etc.)
                      "@log" = {
                        mountpoint = "/var/log";
                        mountOptions = [ "compress=zstd:3" "noatime" ];
                      };
                      # Snapshots root
                      "@snapshots" = {
                        mountpoint = "/.snapshots";
                        mountOptions = [ "compress=zstd:3" "noatime" ];
                      };
                      # Swapfile lives on its own subvolume (CoW must be off)
                      "@swap" = {
                        mountpoint = "/swap";
                        mountOptions = [ "noatime" ];
                        swap.swapfile = {
                          size = "32G";
                          path = "swapfile";
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
