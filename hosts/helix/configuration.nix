## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `helix`
##
## Lenovo Ideapad 320
##

{ config, lib, ... }:

{
  custom =
  {
    # {{{ Boot
    boot =
    {
      sysctl.vm.swappiness = 30;

      # {{{ UEFI
      uefi =
      {
        enable = true;
        secure-boot.enable = true;
      };
      # }}}
    };
    # }}}

    # {{{ Hardware
    hardware.laptop =
    {
      batteryId = "BAT0";
      ignoreLid = true;
    };
    # }}}

    # {{{ Programs
    programs =
    {
      # {{{ Git
      git =
      {
        enable    = true;
        userName  = "Andy3153";
        userEmail = "andy3153@protonmail.com";
      };
      # }}}

      # {{{ Neovim
      neovim =
      {
        enable              = true;
        enableCustomConfigs = true;
      };
      # }}}

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
          # {{{ `fidget`
          "fidget" =
          {
            HostName       = "fidget";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-fidget"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-fidget -C "helix-fidget"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ `petridish`
          "petridish" =
          {
            HostName       = "petridish";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-petridish"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-petridish -C "helix-petridish"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ `sparkle`
          "sparkle" =
          {
            HostName       = "sparkle";
            User           = mainUser;
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-sparkle"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-sparkle -C "helix-sparkle"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ GitHub
          "github.com" =
          {
            HostName       = "github.com";
            User           = "git";
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-github"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-github -C "helix-github"
            IdentitiesOnly = true;
          };
          # }}}

          # {{{ GitLab
          "gitlab.com" =
          {
            HostName       = "gitlab.com";
            User           = "git";
            IdentityFile   = "${homeDir}/.ssh/id_ed25519-gitlab"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-gitlab -C "helix-gitlab"
            IdentitiesOnly = true;
          };
          # }}}
        };
        # }}}
      };
      # }}}

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
              subvolume."home".snapshot_create    = "onchange";
            };
          };
        };
        # }}}
      };
      # }}}

      flatpak.enable = lib.mkForce false;

      # {{{ OpenSSH
      openssh =
      {
        enable         = true;
        authorizedKeys =
        [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMsMVykBqi2V3HxnUYynkCKEQJC01Res7BS92rCQeb/x fidget-helix"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEk+asg/DjhZYAM+JpUm3J1pDqN8fEnk+LEAfk8jVt3 petridish-helix"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPr4Tm7o9ZOI6ywso8Cp0uLXuIIcB1i9KBlWTAVVHwef sparkle-helix"
        ];

        settings =
        {
          PasswordAuthentication = false;
          X11Forwarding          = true;
        };
      };
      # }}}

      # {{{ Syncthing
      syncthing =
      let
      configPath = config.custom.filesystems.vg.helix.lvs.data.subvolumes."/syncthing-conf".mountpoint;
      dataPath   = config.custom.filesystems.vg.helix.lvs.data.subvolumes."/root".mountpoint;
      in
      {
        enable    = true;
        configDir = configPath;
        dataDir   = dataPath;

        # {{{ Settings
        settings =
        {
          # {{{ Devices
          devices =
          {
            fidget.id    = "FUHU63F-LN6AT7C-2H7PSDB-UMLSTE2-WM4KW4M-BBYDQ7Q-MXD5BMR-SLOWZQY";
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
    };
    # }}}

    # {{{ Users
    users.mainUser = "andy3153";
    # }}}

    # {{{ Virtualisation
    virtualisation.docker =
    {
      enable       = true;
      enableOnBoot = true;
    };
    # }}}

    system.stateVersion = "24.11";
  };
}
