## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `fidget`
##
## Lenovo ThinkPad X280
##

{ config, lib, pkgs, pkgs-unstable, pkgs-stable, my-pkgs, ... }:

{
  custom =
  {
    # {{{ Boot
    boot =
    {
      kernel = pkgs.linuxPackages_zen;

      # {{{ Sysctl
      sysctl =
      {
        kernel.sysrq  = 244; # enable REISUB
        vm.swappiness = 10;
      };
      # }}}

      # {{{ UEFI
      uefi =
      {
        enable = true;
        secure-boot.enable = true;
      };
      # }}}
    };
    # }}}

    # {{{ GUI
    gui =
    {
      enable                     = true;
      gaming.enable              = true;
      rices.hyprland-rice.enable = true;
    };
    # }}}

  # {{{ Extra packages
  extraPackages = lib.lists.flatten
  [
    # {{{ Default NixPkgs
    (with pkgs;
    [
      # {{{ Browsers
      brave
      tor-browser # Tor
      # }}}

      # {{{ Media
      cantata      # music-player for-mpd
      pear-desktop # music-player youtube-music

      flac       # music
      opus-tools # music
      mousai     # music find-music

      ffmpeg     # media-convert
      yt-dlp     # media-download
      converseen # media-convert

      exiftool # image-data
      # }}}

      # {{{ Office
      libreoffice-qt6           # Office
      onlyoffice-desktopeditors # Office
      gimp3-with-plugins        # Office photo-editing
      inkscape                  # Office photo-editing

      texliveFull                # LaTeX
      texpresso                  # for-latex
      python314Packages.pygments # for-latex
      pandoc                     # for-latex
      ghostscript                # for-latex pdf-tools

      pdftk         # pdf-tools
      pdfarranger   # pdf-tools
      poppler-utils # pdf-tools

      pomodoro-gtk # timer pomodoro-timer
      timewarrior  # timer time-tracker
      # }}}

      # {{{ Partitioning/Filesystems
      gparted # Partition-Manager
      fatsort # Filesystems sort-fat-fs

      (testdisk.override
      {
        enableQt = true;
        enableNtfs = true;
        enableExtFs = true;
      })

      f3 # flash-drive-tester
      # }}}

      # {{{ Programming
      gh # github for-git
      # }}}

      # {{{ Social
      ferdium # Social
      # }}}

      # {{{ Sound
      qpwgraph    # Sound PipeWire Patchbay
      easyeffects # Sound PipeWire
      pulsemixer  # Sound sound-control
      # }}}

      linux-wifi-hotspot # Internet hotspot
      okteta             # KDE-Apps hex-editor
      qbittorrent        # torrents
      wimlib             # .wim
      woeusb             # flash-usbs windows
      d-spy              # D-Bus
      jq                 # Other-CLI json
      hjson              # Other-CLI json
    ])
    # }}}

    # {{{ NixPkgs Unstable
    (with pkgs-unstable;
    [
    ])
    # }}}

    # {{{ NixPkgs Stable
    (with pkgs-stable;
    [
    ])
    # }}}

    # {{{ My Nix packages
    (with my-pkgs;
    [
    ])
    # }}}
  ];
  # }}}

    # {{{ Hardware
    hardware =
    {
      # {{{ Bluetooth
      bluetooth =
      {
        enable = true;
        powerOnBoot = false;
      };
      # }}}

      laptop.batteryId   = "BAT0";
      thunderbolt.enable = true;
    };
    # }}}

    # {{{ Nix
    nix =
    {
      allowUnfree = lib.mkForce false; # tryna keep this device free of non-source available programs

      # {{{ Unfree whitelist
      unfreeWhitelist =
      [
      ];
      # }}}

      # {{{ Insecure whitelist
      insecureWhitelist =
      [
      ];
      # }}}
    };
    # }}}

    # {{{ Programs
    programs =
    {
      android-tools.enable = true;
      appimage.enable      = true;
      direnv.enable        = true;

      # {{{ Git
      git =
      {
        enable     = true;
        lfs.enable = true;
        userName   = "Andy3153";
        userEmail  = "andy3153@protonmail.com";
      };
      # }}}

      librewolf.enable = true;

      # {{{ Neovim
      neovim =
      {
        enable              = true;
        enableCustomConfigs = true;
      };
      # }}}

      obs.enable = true;

      # {{{ SSH
      ssh =
      {
        enable = true;

        # {{{ Settings
        settings =
        # {{{ Variables
        let
          mainUser = config.custom.users.mainUser;
          HM       = config.home-manager.users.${mainUser};
          homeDir  = HM.home.homeDirectory;
        in
        # }}}
        {
          # {{{ `helix`
          "helix" =
          {
            HostName       = "helix";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "fidget-helix"
            IdentitiesOnly = true;
          };

          "andy3153.am-furnici.ro" =
          {
            HostName       = "andy3153.am-furnici.ro";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "fidget-helix"
            IdentitiesOnly = true;
          };

          "andy3153.go.ro" =
          {
            HostName       = "andy3153.go.ro";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "fidget-helix"
            IdentitiesOnly = true;
          };

          "andy3153.duckdns.org" =
          {
            HostName       = "andy3153.duckdns.org";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "fidget-helix"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ `petridish`
          "petridish" =
          {
            HostName       = "petridish";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-petridish"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-petridish -C "fidget-petridish"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ `sparkle`
          "sparkle" =
          {
            HostName       = "sparkle";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-sparkle"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-sparkle -C "fidget-sparkle"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ GitHub
          "github.com" =
          {
            HostName       = "github.com";
            User           = "git";
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-github"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-github -C "fidget-github"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ GitLab
          "gitlab.com" =
          {
            HostName       = "gitlab.com";
            User           = "git";
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-gitlab"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-gitlab -C "fidget-gitlab"
            IdentitiesOnly = true;
          };
          # }}}
        };
        # }}}
      };
      # }}}

      vesktop.enable   = true;

      # {{{ Zsh
      zsh =
      {
        enable              = true;
        enableCustomConfigs = true;
      };
      # }}}
    };
    # }}}

    # {{{ Services
    services =
    {
      # {{{ Btrbk
      btrbk.instances =
      {
        # {{{ Main daily local snapshot
        ##
        ## Contains subvolumes from the main disk that get backed up daily, and kept locally as snapshots
        ##

        main-daily-local =
        let
          btrfsRoot = config.custom.filesystems.disk.main.partitions.main.subvolumes."/".mountpoint;
        in
        {
          onCalendar = "daily";
          settings =
          {
            timestamp_format = "long";

            snapshot_preserve     = "5d";
            snapshot_preserve_min = "2d";

            volume."${btrfsRoot}" =
            {
              snapshot_dir = "snapshots";

              subvolume."root".snapshot_create    = "onchange";
              subvolume."nix".snapshot_create     = "onchange";
              subvolume."persist".snapshot_create = "onchange";
              subvolume."vm".snapshot_create      = "onchange";
              subvolume."home".snapshot_create    = "onchange";
              subvolume."games".snapshot_create   = "onchange";
            };
          };
        };
        # }}}
      };
      # }}}

      flatpak.enable = true;
      mpd.enable     = true;

      # {{{ OpenSSH
      openssh =
      {
        enable   = true;

        authorizedKeys =
        [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQkW45bzp2hHQCOp+gEr40M3A8gIuIry5bEODCptSe4 helix-fidget"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGdJLOjYrtHeZ5HsHXE4p/jWYuRfrHmnIMxMWLnupbT petridish-fidget"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBtODZzXOKoANvtRn/ED9HN6xMwOph1YxbDMDKkY7ZU sparkle-fidget"
        ];

        settings = { X11Forwarding = true; };
      };
      # }}}

      # {{{ Printing
      printing =
      {
        enable  = true;
        drivers = [ pkgs.brlaser ];
      };
      # }}}

      # {{{ Syncthing
      syncthing =
      {
        enable = true;

        # {{{ Settings
        settings =
        {
          # {{{ Devices
          devices =
          {
            helix.id     = "HSOTOT3-GFSPHFX-HIXQGGC-6CDJBEJ-4VVHCGD-KZADLHY-XC4UEXY-UITFAAY";
            petridish.id = "5TQX52Q-SDYSIF3-CSXU67C-SQKM2BP-GW4KVZA-2SW7LZT-2CJNQZT-TSX7MQ2";
            sparkle.id   = "6AEML4G-3CB4SF3-A4K4R55-2IUBLPP-COG4722-4Q765Z3-XQGVJKH-IMI6ZQG";
          };
          # }}}

          # {{{ Folders
          folders =
          {
          };
          # }}}
        };
        # }}}
      };
      # }}}

      # {{{ TLP
      tlp =
      {
        enable = true;
        chargeThreshold.stop = 80;
      };
      # }}}

      upower.enable = true;
    };
    # }}}

  # {{{ Specialisations
  specialisation =
  {
    # {{{ No firewall
    noFirewall.configuration =
    {
      system.nixos.tags                     = [ "no-firewall" ];
      environment.etc."specialisation".text = "noFirewall"; # for nh

      networking.firewall.enable         = lib.mkForce false;
      custom.services.zerotierone.enable = true;
    };
    # }}}
  };
  # }}}

    # {{{ Users
    users.mainUser = "andy3153";
    # }}}

    # {{{ Virtualisation
    virtualisation =
    {
      # {{{ Docker
      docker =
      {
        enable       = true;
        enableOnBoot = false;
      };
      # }}}

      #libvirtd.enable  = true;
      podman.enable    = true;
    };
    # }}}

    system.stateVersion = "25.11";
  };
}
