## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `sparkle`
##
## ASUS TUF F15 FX506HM
##

{ config, lib, pkgs, pkgs-andy3153, ... }:

{
  imports =
  [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  # {{{ Custom modules
  custom =
  {
    # {{{ Boot
    boot =
    {
      kernel            = pkgs.linuxKernel.packages.linux_zen;
      plymouth.enable   = true;
      reisub.enable     = true;
      sysctl.swappiness = 30;
      uefiBoot.enable   = true;
    };
    # }}}

    # {{{ GUI
    gui =
    {
      enable = true;
      gaming.enable = true;
    };
    # }}}

    # {{{ Hardware
    hardware =
    {
      bluetooth =
      {
        enable      = true;
        powerOnBoot = false;
      };

      controllers.xbox.enable = true;
      graphictablets.enable   = true;
      opengl.enable           = true;
      openrgb.enable          = true;
      nvidia.prime.enable     = true;
    };
    # }}}

    # {{{ Programs
    programs =
    {
      java.enable = true;
      obs.enable  = true;
    };
    # }}}

    # {{{ Services
    services =
    {
      ananicy.enable  = true;
      flatpak.enable  = true;
      pipewire.enable = true;

      printing =
      {
        enable  = true;
        drivers = [ pkgs.brlaser ];
      };
    };
    # }}}

    # {{{ Users
    users.andy3153.enable = true;
    # }}}

    # {{{ Virtualisation
    virtualisation =
    {
      docker =
      {
        enable       = false;
        enableOnBoot = false;
      };

      libvirtd.enable = true;
      waydroid.enable = false;
    };
    # }}}
  };
  # }}}

  # {{{ Hosts file block list
  networking.stevenblack.enable = true;
  # }}}

  # {{{ Battery charging limit
  hardware.asus.battery =
  {
    chargeUpto             = 90;
    enableChargeUptoScript = true;
  };
  # }}}

  # {{{ Btrbk instances
  services.btrbk.instances =
  {
    # {{{ Daily local backup
    ##
    ## Contains subvolumes that get backed up daily, and kept locally as snapshots
    ##

    daily-local =
    {
      #onCalendar = "daily";
      onCalendar = "null";
      settings =
      {
        timestamp_format      = "long";

        snapshot_preserve     = "5d";
        snapshot_preserve_min = "2d";

        volume."/.btrfs-root" =
        {
          snapshot_dir = "snapshots";
          subvolume."root".snapshot_create = "onchange";
          subvolume."nix".snapshot_create = "onchange";
          subvolume."home".snapshot_create = "onchange";
        };
      };
    };
    # }}}

    # {{{ Backup to external hard drive
    ##
    ## Contains subvolumes that get backed up to an external hard drive
    ##

    externalhdd =
    {
      onCalendar = "null";
      settings =
      {
        timestamp_format      = "long";

        snapshot_preserve_min = "latest";

        volume."/.btrfs-root" =
        {
          snapshot_dir = "snapshots.externalhdd";

          subvolume."root".snapshot_create = "onchange";
          subvolume."root".target = "/mnt/sparkle_snapshots/";

          subvolume."nix".snapshot_create = "onchange";
          subvolume."nix".target = "/mnt/sparkle_snapshots/";

          subvolume."home".snapshot_create = "onchange";
          subvolume."home".target = "/mnt/sparkle_snapshots/";
        };
      };
    };
    # }}}

    # {{{ Backup to external hard drive (full)
    ##
    ## Contains subvolumes that get backed up to an external hard drive
    ##

    externalhdd-full =
    {
      onCalendar = "null";
      settings =
      {
        timestamp_format      = "long";

        snapshot_preserve_min = "latest";

        volume."/.btrfs-root" =
        {
          snapshot_dir = "snapshots.externalhdd";

          subvolume."root".snapshot_create = "onchange";
          subvolume."root".target = "/mnt/sparkle_snapshots/";

          subvolume."nix".snapshot_create = "onchange";
          subvolume."nix".target = "/mnt/sparkle_snapshots/";

          subvolume."home".snapshot_create = "onchange";
          subvolume."home".target = "/mnt/sparkle_snapshots/";

          subvolume."games".snapshot_create = "onchange";
          subvolume."games".target = "/mnt/sparkle_snapshots/";

          subvolume."vms".snapshot_create = "onchange";
          subvolume."vms".target = "/mnt/sparkle_snapshots/";

          subvolume."torrents".snapshot_create = "onchange";
          subvolume."torrents".target = "/mnt/sparkle_snapshots/";

          subvolume.".beeshome".snapshot_create = "onchange";
          subvolume.".beeshome".target = "/mnt/sparkle_snapshots/";
        };
      };
    };
    # }}}
  };
  # }}}

  # {{{ Video drivers
  services.xserver.videoDrivers = lib.mkForce
  [
    "modesetting"
    "intel"
    "nvidia"
    "fbdev"
  ];
  # }}}
}
