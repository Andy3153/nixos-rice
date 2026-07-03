## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `sparkle`
##
## ASUS TUF F15 FX506HM
##

{ config, lib, pkgs, pkgs-unstable, pkgs-stable, my-pkgs, ... }:

# {{{ Variables
let
  mainUser = config.custom.users.mainUser;
  HM       = config.home-manager.users.${mainUser};
  homeDir  = HM.home.homeDirectory;
in
# }}}
{
  # {{{ BeamMP certificate problem
  security.pki.certificateFiles =
  [(pkgs.stdenvNoCC.mkDerivation
  {
    name = "beammp-cert";
    nativeBuildInputs = [ pkgs.curl ];
    builder = (pkgs.writeScript "beammp-cert-builder" "curl -w %{certs} https://auth.beammp.com/userlogin -k > $out");
    outputHash = "sha256-sB60qscvpKwqLYeAKrdef2Nf9U+F8UDNfniAZ7f8Kno=";
  })];
  # }}}

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
    let
      bottles = pkgs.bottles.override { removeWarningPopup = true; };
    in
    [
      # {{{ 3D
      blender # 3D
      # }}}

      # {{{ Browsers
      brave
      tor-browser # Tor
      # }}}

      # {{{ Gaming
      lutris  # launchers for-wine
      heroic  # launchers games

      prismlauncher       # games
      xonotic             # games
      osu-lazer-bin       # games
      space-cadet-pinball # games

      dolphin-emu # emulators games gc wii
      mesen       # emulators games nes snes gb gbc gba pcengine gamegear wonderswan

      beammp-launcher # for-beamng
      # }}}

      # {{{ Media
      cantata      # music-player for-mpd
      pear-desktop # music-player youtube-music

      grayjay # youtube

      flac       # music
      opus-tools # music
      mousai     # music find-music
      picard     # music tag-music
      lrcget     # music get-lyrics
      shntool    # music split-cue

      ffmpeg     # media-convert
      yt-dlp     # media-download
      converseen # media-convert

      audacity # audio-editor

      exiftool # image-data
      # }}}

      # {{{ Office
      libreoffice-qt6           # Office
      onlyoffice-desktopeditors # Office
      wpsoffice                 # Office
      gimp3-with-plugins        # Office photo-editing
      inkscape                  # Office photo-editing
      krita                     # Office photo-editing

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

      # {{{ Wine
      wineWow64Packages.staging # wine
      bottles                   # launchers for-wine
      # }}}

      linux-wifi-hotspot # Internet hotspot
      okteta             # KDE-Apps hex-editor
      qbittorrent        # torrents
      wimlib             # .wim
      ventoy-full        # flash-usbs
      woeusb             # flash-usbs windows
      d-spy              # D-Bus
      openbox            # for-xwayland-rootless-script
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
      # {{{ Media
      syrics                              # music get-lyrics
      # }}}
    ])
    # }}}
  ];
  # }}}

  # {{{ Extra Flatpak packages
  extraFlatpakPackages =
  [
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

      # {{{ GPU drivers
      gpuDrivers = lib.mkForce
      [
        "modesetting"
        "intel"
        "nvidia"
        "fbdev"
      ];
      # }}}

      graphictablets.enable = true;

      # {{{ Laptop
      laptop =
      {
        batteryId = "BAT1";
        ignoreLid = true;
      };
      # }}}

      # {{{ NVIDIA
      nvidia =
      {
        enable       = true;
        prime.enable = true;
      };
      # }}}

      openrgb.enable     = true;
      piper.enable       = true;
      thunderbolt.enable = true;
    };
    # }}}

    # {{{ Nix
    nix =
    {
      # {{{ Unfree whitelist
      unfreeWhitelist =
      [
        "SpaceCadetPinball"
        "grayjay"
        "osu-lazer-bin"
        "ventoy"
        "wpsoffice"
      ];
      # }}}

      # {{{ Insecure whitelist
      insecureWhitelist =
      [
        "ventoy-1.1.12"
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
      spicetify.enable = true;
      steam.extraPackages = [ pkgs.nss ]; # for-beamng

      # {{{ SSH
      ssh =
      {
        enable = true;

        # {{{ Settings to use with different hosts
        matchBlocks =
        {
          # {{{ `fidget`
          "fidget" =
          {
            hostname       = "fidget";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-fidget"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-fidget -C "sparkle-fidget"
            identitiesOnly = true;
          };
          # }}}

          # {{{ `helix`
          "helix" =
          {
            hostname       = "helix";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            identitiesOnly = true;
          };

          "andy3153.am-furnici.ro" =
          {
            hostname       = "andy3153.am-furnici.ro";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            identitiesOnly = true;
          };

          "andy3153.go.ro" =
          {
            hostname       = "andy3153.go.ro";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            identitiesOnly = true;
          };

          "andy3153.duckdns.org" =
          {
            hostname       = "andy3153.duckdns.org";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            identitiesOnly = true;
          };
          # }}}

          # {{{ `petridish`
          "petridish" =
          {
            hostname       = "petridish";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-petridish"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-petridish -C "sparkle-petridish"
            identitiesOnly = true;
          };
          # }}}

          # {{{ GitHub
          "github.com" =
          {
            hostname       = "github.com";
            user           = "git";
            identityFile   = "${homeDir}/.ssh/id_ed25519-github"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-github -C "sparkle-github"
            identitiesOnly = true;
          };
          # }}}

          # {{{ GitLab
          "gitlab.com" =
          {
            hostname       = "gitlab.com";
            user           = "git";
            identityFile   = "${homeDir}/.ssh/id_ed25519-gitlab"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-gitlab -C "sparkle-gitlab"
            identitiesOnly = true;
          };
          # }}}
        };
        # }}}
      };
      # }}}

      tilp2.enable     = true;
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGTx7a/6tDwUl3W5QALJ1rUWQbViapPoZU9EOhCdYW9e fidget-sparkle"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODo31jXxNZXr0giOaIIklFu0qyDmWZqNYoAaQKpAE5u helix-sparkle"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPBC1astmlTT1tjhrfPXqFPly1GxauR4S7qU3CCzwIFK petridish-sparkle"
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
      # {{{ Variables
      let
        cfg     = config.custom.services.syncthing;
        devices = builtins.attrNames cfg.settings.devices;

        _1min = 60;
        _1hr  = _1min * 60;
        _1d   = _1hr  * 24;

        mkFolder = name: path: extraParams:
        {
          "${name}" =
          {
            inherit devices path;

            copyOwnershipFromParent = true;

            id    = name;
            label = name;

            versioning =
            {
              type = "staggered";
              cleanupIntervalS = _1hr;
              params =
              {
                cleanoutDays = 2;
                keep = 5;
                maxAge = _1d * 3;
              };
            };
          } // extraParams;
        };
      in
      # }}}
      {
        enable = true;

        # {{{ Settings
        settings =
        {
          # {{{ Devices
          devices =
          {
            fidget.id    = "FUHU63F-LN6AT7C-2H7PSDB-UMLSTE2-WM4KW4M-BBYDQ7Q-MXD5BMR-SLOWZQY";
            helix.id     = "HSOTOT3-GFSPHFX-HIXQGGC-6CDJBEJ-4VVHCGD-KZADLHY-XC4UEXY-UITFAAY";
            petridish.id = "5TQX52Q-SDYSIF3-CSXU67C-SQKM2BP-GW4KVZA-2SW7LZT-2CJNQZT-TSX7MQ2";
          };
          # }}}

          # {{{ Folders
          folders =
            #mkFolder "docs" "~/docs"       {} //

            mkFolder "downs" "~/downs"
            {
              ignorePatterns =
              [
                "!/torrents/#### torrent files ####"
                "/torrents/*"
                "**/*.crdownload"
                "**/*.part"
              ];
            }; #} //

            #mkFolder "etc" "~/etc"        {} //
            #
            #mkFolder "games" "~/games"
            #{
            #  ignorePatterns =
            #  [
            #  ];
            #} //
            #
            #mkFolder "music"      "~/music"      {} //
            #mkFolder "music_opus" "~/music_opus" {} //
            #mkFolder "phone"      "~/phone"      {} //
            #mkFolder "pics"       "~/pics"       {} //
            #mkFolder "progs"      "~/progs"      {} //
            #mkFolder "src"        "~/src"        {} //
            #mkFolder "vids"       "~/vids"       {};
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

    # {{{ GPU passthrough to VM
    gpuPassthrough.configuration =
    {
      system.nixos.tags                     = [ "gpu-passthrough" ];
      environment.etc."specialisation".text = "gpuPassthrough"; # for nh

      custom =
      {
        hardware =
        {
          gpuPassthrough =
          {
            enable = true;
            cpu    = "intel";
            gpu    = "nvidia";
            gpuIDs = [ "10de:2520" "10de:228e" ]; # 3060 mobile
          };

          nvidia =
          {
            enable       = lib.mkForce false;
            prime.enable = lib.mkForce false;
          };
        };
      };
    };
    # }}}
  };
  # }}}

    # {{{ Systemd
    systemd.services =
    {
      # {{{ Reverse SSH tunnel to `helix`
      reverseSshTunnel =
      {
        enable = true;
        user   = mainUser;

        sshKeyPath = "${homeDir}/.ssh/id_ed25519-helix";

        remote =
        {
          address = "andy3153.am-furnici.ro";
          port    = 8022;
        };

        host =
        {
          address = "localhost";
          port    = 22;
        };
      };
      # }}}

      tufFanSpeed.enable = true;
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

      libvirtd.enable  = true;
      podman.enable    = true;
    };
    # }}}

    system.stateVersion = "25.11";
  };
}
