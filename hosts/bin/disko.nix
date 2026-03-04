{
  devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        # Keep Windows dual-boot partitions intact: never wipe the whole disk.
        destroy = false;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              label = "ESP";
              # Use the existing EFI partition directly.
              device = "/dev/nvme0n1p1";
              start = "1M";
              end = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              # Reuse the existing Linux root partition (p2) only.
              name = "root";
              label = "root";
              device = "/dev/nvme0n1p2";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                  };
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                  "/nix" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap = {
                      swapfile.size = "2G";
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
