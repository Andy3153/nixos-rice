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
            "EFI System Partition" =
            {
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

            # {{{ `helix` (LVM PV)
            "helix" =
            {
              size = "100%";

              content =
              {
                type = "lvm_pv";
                vg   = "helix";
              };
            };
            # }}}
          };
          # }}}
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
          # {{{ `root`
          "root" =
          {
            size = "50G";

            content =
            {
              type       = "btrfs";
              extraArgs  = [ "-f" ];
              mountpoint = "/.btrfs-root";

              # {{{ Btrfs subvolumes
              subvolumes =
              {
                "/root" =
                {
                  mountpoint = "/";
                };

                "/nix" =
                {
                  mountpoint = "/nix";
                };

                "/home" =
                {
                  mountpoint = "/home";
                };

                "/swap" =
                {
                  mountpoint = "/.swap";
                  swap.swapfile.size = "10G";
                };

                "/snapshots" =
                {
                  mountpoint = "/.snapshots";
                };

                "/var-cache" =
                {
                  mountpoint = "/var/cache";
                };

                "/var-log" =
                {
                  mountpoint = "/var/log";
                };

                "/var-tmp" =
                {
                  mountpoint = "/var/tmp";
                };
              };
              # }}}
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
