{
  disko.devices.disk = {
    root = {
      type = "disk";
      device = "/dev/disk/by-diskseq/1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            start = "1M";
            size = "600M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
            };
          };
          boot = {
            size = "1G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  #mountOptions = ["compress=zstd:1" "noatime"];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = ["compress=zstd:1" "noatime"];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd:1" "noatime"];
                };
              };
            };
          };
        };
      };
    };
    data = {
      type = "disk";
      device = "/dev/disk/by-diskseq/2";
      content = {
        type = "gpt";
        partitions = {
          btrfs-toplevel = {
            size = "100%";
            label = "chain-data";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              mountpoint = "/chain/btrfs-toplevel";
              mountOptions = ["compress=zstd:1" "nofail"];
              subvolumes = {
                "/data" = {
                  mountpoint = "/chain/.home/data";
                  mountOptions = ["compress=zstd:1" "nofail"];
                };
              };
            };
          };
        };
      };
    };
  };
}
