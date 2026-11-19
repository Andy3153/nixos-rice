## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `sparkle`
##
## ASUS TUF F15 FX506HM
##

{ config, lib, pkgs, pkgGroups, ... }:

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
    outputHash = "sha256-IPJdqIU9GHuygEQf34poIALHaI9y3/HIEmVPwSauLMg=";
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
    # {{{ Package groups
    (with pkgGroups;
    [
      _3d
      browsers
      fs

      gaming.emulators
      gaming.games
      gaming.launchers

      media.audio.convert
      media.audio.edit
      media.audio.play
      media.audio.tools

      media.image.convert
      media.image.edit
      media.image.editExtras

      media.convert
      media.download

      office.wysiwyg
      office.latex
      office.pdf

      programming
      social
      wine
    ])
    # }}}

    (with pkgs;
    [
      unityhub
      linux-wifi-hotspot # Internet hotspot
      qbittorrent        # torrents
      wimlib             # .wim
      ventoy-full-qt     # flash-usbs
      woeusb             # flash-usbs windows
      d-spy              # D-Bus
      openbox            # for-xwayland-rootless-script
      jq                 # Other-CLI json
      hjson              # Other-CLI json
    ])
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

      laptop.batteryId = "BAT1";

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
        "lsfg-vk"           # for-bottles
        "osu-lazer-bin"
        "unityhub"
        "ventoy-qt5"
        "wpsoffice"
      ];
      # }}}

      # {{{ Insecure whitelist
      insecureWhitelist =
      [
        "ventoy-qt5-1.1.18"
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

      obs.enable       = true;
      spicetify.enable = true;

      steam.extraPackages = [ pkgs.nss ]; # for-beamng

      # {{{ SSH
      ssh =
      {
        enable = true;

        # {{{ Settings
        settings =
        {
          # {{{ `fidget`
          "fidget" =
          {
            HostName       = "fidget";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-fidget"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-fidget -C "sparkle-fidget"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ `helix`
          "helix" =
          {
            HostName       = "helix";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            IdentitiesOnly = true;
          };

          "andy3153.am-furnici.ro" =
          {
            HostName       = "andy3153.am-furnici.ro";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            IdentitiesOnly = true;
          };

          "andy3153.go.ro" =
          {
            HostName       = "andy3153.go.ro";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            IdentitiesOnly = true;
          };

          "andy3153.duckdns.org" =
          {
            HostName       = "andy3153.duckdns.org";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ `petridish`
          "petridish" =
          {
            HostName       = "petridish";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-petridish"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-petridish -C "sparkle-petridish"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ GitHub
          "github.com" =
          {
            HostName       = "github.com";
            User           = "git";
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-github"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-github -C "sparkle-github"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ GitLab
          "gitlab.com" =
          {
            HostName       = "gitlab.com";
            User           = "git";
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-gitlab"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-gitlab -C "sparkle-gitlab"
            IdentitiesOnly = true;
          };
          # }}}
        };
        # }}}
      };
      # }}}

      vesktop.enable           = true;
      yazi.enableCustomConfigs = true;

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

      flatpak.enable   = true;

      # {{{ Llama.CPP
      llama-cpp =
      {
        enable = true;

        # {{{ LLM settings
        llmSettings.ctxSize = 262144;
        # }}}

        # {{{ Models
        models =
        {
          # {{{ Standard model
          "Qwen3.5 (9B)" =
          {
            hf-repo = "unsloth/Qwen3.5-9B-GGUF";
            hf-file = "Qwen3.5-9B-UD-Q4_K_XL.gguf";
            alias   = "Qwen3.5-9B";
            temp    = "0.6";
            top-p   = "0.95";
            top-k   = "20";
            min-p   = "0.00";
            jinja   = "on";
          };
          # }}}

          # {{{ Smaller model
          "Qwen3.5 (4B)" =
          {
            hf-repo = "unsloth/Qwen3.5-4B-GGUF";
            hf-file = "Qwen3.5-4B-UD-Q4_K_XL.gguf";
            alias   = "Qwen3.5-4B";
            temp    = "0.6";
            top-p   = "0.95";
            top-k   = "20";
            min-p   = "0.00";
            jinja   = "on";
          };
          # }}}

          # {{{ Abliterated model
          "Qwen3.5 Abliterated (9B)" =
          {
            hf-repo = "lukey03/Qwen3.5-9B-abliterated-GGUF";
            hf-file = "Qwen3.5-9B-abliterated-Q4_K_M.gguf";
            alias   = "Qwen3.5-9B-abliterated";
            temp    = "0.6";
            top-p   = "0.95";
            top-k   = "20";
            min-p   = "0.00";
            jinja   = "on";
          };
          # }}}

          # {{{ Coding model
          "Qwen2.5 Coder (7B)" =
          {
            hf-repo = "unsloth/Qwen2.5-Coder-7B-Instruct-GGUF";
            hf-file = "Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf";
            alias   = "Qwen2.5-Coder-7B";
            temp    = "0.2";
            top-p   = "0.95";
            top-k   = "40";
            jinja   = "on";
          };
          # }}}
        };
        # }}}
      };
      # }}}

      mpd.enable       = true;

      # {{{ OpenSSH
      openssh =
      {
        enable   = true;

        authorizedKeys =
        [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLg+vX9B9UWm/kHkmF2mTx7AZl3FwbHg0jORiYS5R49 fidget-sparkle"
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
