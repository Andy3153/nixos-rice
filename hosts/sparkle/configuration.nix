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

  environment.systemPackages = [ pkgs-andy3153.hunspellDicts.ro_RO ];

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
    gui.enable             = true;
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
      steam.enable = true;
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

  networking.stevenblack.enable             = true;

  hardware.asus.battery =
  {
    chargeUpto             = 90;
    enableChargeUptoScript = true;
  };

  # {{{ Flatpak packages
  services.flatpak.packages =
  [
    "com.github.tchx84.Flatseal"         # Base-System
    "io.gitlab.librewolf-community"      # Browsers
    "com.brave.Browser"                  # Browsers
    "org.torproject.torbrowser-launcher" # Browsers Tor

    "com.discordapp.Discord"             # Social
    "io.github.trigg.discover_overlay"   # for-discord
    "org.ferdium.Ferdium"                # Social

    "com.spotify.Client"                 # Music-Players

    "sh.ppy.osu"                         # Games
  ];
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



  # {{{ Boot
  boot =
  {
    # {{{ Extra module packages
    extraModulePackages = with config.boot.kernelPackages;
    [
      v4l2loopback
    ];
    # }}}

    # {{{ Extra modprobe config
    extraModprobeConfig =
    ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    # }}}
  };
  # }}}

  # {{{ Programs
  programs =
  {
    gamemode.enable = true; # games
    java.enable     = true; # Programming
  };
  # }}}

  # {{{ Services
  services =
  {
    # {{{ X Server
    xserver.videoDrivers =
    [
      "modesetting"
      "intel"
      "nvidia"
      "fbdev"
    ];
    # }}}
  };
  # }}}

  # {{{ XDG
  xdg =
  {
    # {{{ MIME
    mime =
    {
      enable = true;

      defaultApplications =
      {
        "text/plain"      = "neovide.desktop";
        "text/html"       = "io.gitlab.librewolf-community.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
    # }}}
  };
  # }}}
}
