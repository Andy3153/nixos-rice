## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Disko config for hostname `sparkle`
##
## ASUS TUF F15 FX506HM
##

{ config, ... }:

let
  mainUser     = config.custom.users.mainUser;
  homeDir      = "/home/${mainUser}"; # ANYTHING ELSE that tries to be more elegant, like `config.users.users.${mainUser}.home` produces an **infinite recursion**. why?
  xdgDownloads = "${homeDir}/downs";  # so I have to make do with this for now...
in
{
  disko.devices =
  {
    # {{{ Disks
    disk =
    {
      # {{{ Main drive (internal SSD)
      main =
      {
        device = "/dev/disk/by-id/nvme-HFM001TD3JX013N_CNA3N80481170434G";
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
              size = "1G";
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
              name = "sparkle";
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

                  "/swap" =
                  {
                    mountpoint = "/.swap";
                    swap.swapfile.size = "18G";
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

                  "/vms" =
                  {
                    mountpoint   = "/var/lib/libvirt/images";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/home" =
                  {
                    mountpoint   = "/home";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/games" =
                  {
                    mountpoint   = "${homeDir}/games";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/games/steam/steamapps/common" =
                  {
                    mountpoint   = "${homeDir}/games/steam/steamapps/common";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/games/steam/steamapps/shadercache" =
                  {
                    mountpoint   = "${homeDir}/games/steam/steamapps/shadercache";
                    mountOptions = [ "compress=zstd" ];
                  };

                  "/torrents" =
                  {
                    mountpoint   = "${xdgDownloads}/torrents";
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
    };
    # }}}
  };
}
