## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Disko config for hostname `helix`
##
## Lenovo Ideapad 320
##

{ ... }:

{
  disko.devices =
  {
    # {{{ Disks
    disk =
    {
      # {{{ Main drive (internal SSD)
      "main" =
      {
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37240G_50026B7380F9A543";
        type   = "disk";

        content =
        {
          type = "gpt";

          # {{{ Partitions
          partitions =
          {
            # {{{ ESP
            esp =
            {
              name = "EFI System Partition";
              size = "2G";
              type = "EF00";

              content =
              {
                type         = "filesystem";
                format       = "vfat";
                mountpoint   = "/boot";
                mountOptions =
                [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };
            # }}}

            # {{{ Main
            main =
            {
              name = "helix";
              size = "100%";

              content =
              {
                type         = "btrfs";
                extraArgs    = [ "-f" ];
                mountpoint   = "/.btrfs-root";
                mountOptions = [ "compress=zstd" ];

                # {{{ Btrfs subvolumes
                subvolumes =
                {
                  "/root" =
                  {
                    mountpoint   = "/";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/nix" =
                  {
                    mountpoint   = "/nix";
                    mountOptions =
                    [
                      "compress=zstd"
                      "noatime"
                    ];
                  };

                  "/home" =
                  {
                    mountpoint   = "/home";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/swap" =
                  {
                    mountpoint = "/.swap";
                    swap.swapfile.size = "10G";
                  };

                  "/snapshots" =
                  {
                    mountpoint   = "/.snapshots";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/var-cache" =
                  {
                    mountpoint   = "/var/cache";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/var-log" =
                  {
                    mountpoint   = "/var/log";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/var-tmp" =
                  {
                    mountpoint   = "/var/tmp";
                    mountOptions = [ "compress=zstd" ];
                  };
                };
                # }}}
              };
            };
            # }}}
          };
          # }}}
        };
      };
      # }}}

      # {{{ Data drive (external HDD)
      "data" =
      {
        device = "/dev/disk/by-id/ata-ST2000DM001-1ER164_Z4Z0WWCV";
        type   = "disk";

        content =
        {
          type = "lvm_pv";
          vg   = "helix";
        };
      };
      # }}}
    };
    # }}}

    # {{{ LVM volume groups
    lvm_vg =
    {
      # {{{ `helix`
      "helix" =
      {
        type = "lvm_vg";

        # {{{ Logical volumes
        lvs =
        {
          # {{{ Docker
          docker =
          {
            size = "5G";

            content =
            {
              type       = "filesystem";
              format     = "ext4";
              mountpoint = "/var/lib/docker";
            };
          };
          # }}}

          # {{{ `sparkle` backups
          sparklebak =
          {
            size = "500G";

            content =
            {
              type       = "filesystem";
              format     = "ext4";
              mountpoint = "/mnt/sparklebak";
            };
          };
          # }}}
        };
        # }}}
      };
      # }}}
    };
    # }}}
  };
}
