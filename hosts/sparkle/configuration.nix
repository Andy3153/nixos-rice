## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `sparkle`
##
## ASUS TUF F15 FX506HM
##

{ config, lib, pkgs, ... }:

{
  imports =
  [
    ./hardware-configuration.nix
    ../../nixosModules/default.nix
    ../../nixosModules/boot/bootbundle.nix
    ../../nixosModules/gui/guibundle.nix
    ../../nixosModules/hardware/hardwarebundle.nix
    ../../nixosModules/services/servicesbundle.nix
    ../../nixosModules/users/usersbundle.nix
    ../../nixosModules/virtualisation/virtualisationbundle.nix
  ];

  custom =
  {
    boot =
    {
      plymouth.enable = true;
      quiet           = true;
    };

    gui =
    {
      dm.sddm.enable = true;
    };

    hardware =
    {
      bluetooth.enable        = true;
      controllers.xbox.enable = true;
      graphictablets.enable   = true;
      opengl.enable           = true;
      openrgb.enable          = true;

      nvidia =
      {
        enable       = true;
        prime.enable = true;
      };
    };

    services =
    {
      ananicy.enable  = true;
      flatpak.enable  = true;
      pipewire.enable = true;
      printing.enable = true;
    };

    users.andy3153.enable = true;

    virtualisation =
    {
      docker.enable   = false;
      libvirtd.enable = false;
      waydroid.enable = false;
    };
  };

  networking.hostName = "sparkle";

  boot.kernelPackages                       = pkgs.linuxPackages_zen;
  boot.kernel.sysctl                        = { "vm.swappiness" = 30; };
  boot.loader.systemd-boot.enable           = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  hardware.cpu.intel.updateMicrocode        = true;
  networking.stevenblack.enable             = true;
  services.printing.drivers                 = with pkgs; [ brlaser ];
  virtualisation.docker.enableOnBoot        = false;

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

  # {{{ Specific for this hardware
  hardware.nvidia.prime =
  {
    intelBusId  = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
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

# {{{ Nix
  nix =
  {
    # {{{ Garbage collector
    gc =
    {
      automatic = true;
      dates     = "weekly";
    };
    # }}}

    # {{{ Settings
    settings =
    {
      # {{{ Enable Hyprland Cachix
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      # }}}
    };
    # }}}
  };
# }}}

  # {{{ Programs
  programs =
  {
    dconf.enable    = true;
    gamemode.enable = true; # games
    hyprland.enable = true; # hyprland-rice wm
    java.enable     = true; # Programming

    # {{{ ReGreet
    #regreet =
    #{
    #  enable = true;
    #};
    # }}}

  # {{{ Steam
  steam =
  {
    enable                       = true;

    #gamescopeSession.enable      = true;

    dedicatedServer.openFirewall = true;
    remotePlay.openFirewall      = true;

  };
  # }}}
  };
  # }}}

  # {{{ Services
  services =
  {
    # {{{ Display manager
    displayManager =
    {
      defaultSession = "hyprland";
    };
    # }}}

    # {{{ X Server
    xserver.videoDrivers =
    [
      "modesetting"
      "intel"
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

    # {{{ Portal
    portal =
    {
      enable = true;

      extraPortals = with pkgs;
      [
        xdg-desktop-portal-gtk
      ];

      config =
      {
        common =
        {
          default = "*";
        };
      };
    };
    # }}}
  };
  # }}}
}
