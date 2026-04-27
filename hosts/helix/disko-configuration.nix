## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Disko config for hostname `helix`
##
## Lenovo Ideapad 320
##

{ config, lib, ... }:

let
  # {{{ Variables
  mainUser     = config.custom.users.mainUser;
  homeDir      = "/home/${mainUser}"; # ANYTHING ELSE that tries to be more elegant, like `config.users.users.${mainUser}.home` produces an **infinite recursion**. why?
  xdgDownloads = "${homeDir}/downs";  # so I have to make do with this for now...

  dataRootMountpoint = "/mnt/data";
  # }}}
in
{
  options.custom.filesystems =
  {
    disk.main.partitions.main.subvolumes = lib.mkOption { internal = true; type = lib.types.anything; };
  };

  config =
  {
    # {{{ Filesystem abstraction aliases
    custom.filesystems.disk.main.partitions.main.subvolumes = lib.mkForce config.disko.devices.disk.main.content.partitions.main.content.subvolumes;
    # }}}

    disko.devices =
    {
      # {{{ Disks
      disk =
      {
        # {{{ Main drive (internal SSD)
        main =
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
                type = "EF00"; # ESP

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

                    "/" =
                    {
                      mountpoint   = "/.btrfs-root";
                      mountOptions = [ "compress=zstd" ];
                    };

                    "/persist" =
                    {
                      mountpoint   = "/.persist";
                      mountOptions = [ "compress=zstd" ];
                    };

                    "/snapshots" =
                    {
                      mountpoint   = "/.snapshots";
                      mountOptions = [ "compress=zstd" ];
                    };

                    "/swap" =
                    {
                      mountpoint = "/.swap";
                      swap.swapfile.size = "10G";
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

                    "/home" =
                    {
                      mountpoint   = "/home";
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
        data =
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
        helix =
        {
          type = "lvm_vg";

          # {{{ Logical volumes
          lvs =
          {
            # {{{ Data
            data =
            {
              size = "1T";

              content =
              {
                type         = "btrfs";
                extraArgs    = [ "-f" ];
                mountOptions = [ "compress=zstd" ];

                # {{{ Btrfs subvolumes
                subvolumes =
                {
                  "/root" =
                  {
                    mountpoint   = "${dataRootMountpoint}";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/" =
                  {
                    mountpoint   = "${dataRootMountpoint}/.btrfs-root";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/persist" =
                  {
                    mountpoint   = "${dataRootMountpoint}/.persist";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/snapshots" =
                  {
                    mountpoint   = "${dataRootMountpoint}/.snapshots";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/vm" =
                  {
                    mountpoint   = "${dataRootMountpoint}/var/lib/libvirt";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/vm-images" =
                  {
                    mountpoint   = "${dataRootMountpoint}/var/lib/libvirt/images";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/home" =
                  {
                    mountpoint   = "${dataRootMountpoint}/home";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/games" =
                  {
                    mountpoint   = "${dataRootMountpoint}${homeDir}/games";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/torrents" =
                  {
                    mountpoint   = "${dataRootMountpoint}${xdgDownloads}/torrents";
                    mountOptions = [ "compress=zstd" ];
                  };
                };
                # }}}
              };
            };
            # }}}

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
  };
}
