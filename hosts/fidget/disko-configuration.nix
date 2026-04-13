## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Disko config for hostname `fidget`
##
## Lenovo ThinkPad X280
##

{ config, lib, ... }:

let
  # {{{ Variables
  mainUser     = config.custom.users.mainUser;
  homeDir      = "/home/${mainUser}"; # ANYTHING ELSE that tries to be more elegant, like `config.users.users.${mainUser}.home` produces an **infinite recursion**. why?
  xdgDownloads = "${homeDir}/downs";  # so I have to make do with this for now...
  # }}}
in
{
  imports =
  [
    (
      lib.mkAliasOptionModule
        [ "custom" "filesystems" "disk" "main" "partitions" "main" "subvolumes" ]
        [ "disko" "devices" "disk" "main" "content" "partitions" "main-crypt" "content" "content" "subvolumes" ]
    )
  ];

  disko.devices =
  {
    # {{{ Disks
    disk =
    {
      # {{{ Main drive (internal SSD)
      main =
      {
        device = "/dev/disk/by-id/ata-SK_hynix_SC401_SATA_256GB_MN93N194311103H0L";
        type   = "disk";

        content =
        {
          type = "gpt";

          # {{{ Partitions
          partitions =
          {
            # {{{ ESP
            esp = rec
            {
              name  = "EFI System Partition";
              label = name;
              size  = "1G";
              type  = "EF00"; # ESP

              content =
              {
                type       = "filesystem";
                format     = "vfat";
                mountpoint = "/boot";

                mountOptions =
                [
                  "fmask=0022"
                  "dmask=0022"
                ];
              };
            };
            # }}}

            # {{{ Main encrypted container
            main-crypt = rec
            {
              name  = "fidget-crypt";
              label = name;
              size  = "100%";

              content =
              {
                name = "fidget";
                type = "luks";

                settings.allowDiscards = true;

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

                    "/persist" =
                    {
                      mountpoint   = "/.persist";
                      mountOptions = [ "compress=zstd" ];
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

                    "/vm" =
                    {
                      mountpoint   = "/var/lib/libvirt";
                      mountOptions = [ "compress=zstd" ];
                    };

                    "/vm-images" =
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

                    "/steam-gamefiles" =
                    {
                      mountpoint   = "${homeDir}/games/steam/steamapps/common";
                      mountOptions = [ "compress=zstd" ];
                    };

                    "/steam-shadercache" =
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
