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
    hardware.laptop.ignoreLid = true;
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

        # {{{ Settings to use with different hosts
        matchBlocks =
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
            hostname       = "fidget";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-fidget"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-fidget -C "helix-fidget"
            identitiesOnly = true;
          };
          # }}}

          # {{{ `petridish`
          "petridish" =
          {
            hostname       = "petridish";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-petridish"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-petridish -C "helix-petridish"
            identitiesOnly = true;
          };
          # }}}

          # {{{ `sparkle`
          "sparkle" =
          {
            hostname       = "sparkle";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-sparkle"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-sparkle -C "helix-sparkle"
            identitiesOnly = true;
          };
          # }}}

          # {{{ GitHub
          "github.com" =
          {
            hostname       = "github.com";
            user           = "git";
            identityFile   = "${homeDir}/.ssh/id_ed25519-github"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-github -C "helix-github"
            identitiesOnly = true;
          };
          # }}}

          # {{{ GitLab
          "gitlab.com" =
          {
            hostname       = "gitlab.com";
            user           = "git";
            identityFile   = "${homeDir}/.ssh/id_ed25519-gitlab"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-gitlab -C "helix-gitlab"
            identitiesOnly = true;
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
        # {{{ Daily local snapshot
        ##
        ## Contains subvolumes that get backed up daily, and kept locally as snapshots
        ##

        daily-local =
        {
          onCalendar = "daily";
          settings =
          {
            timestamp_format = "long";

            snapshot_preserve     = "5d";
            snapshot_preserve_min = "2d";

            volume."/.btrfs-root" =
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
      {
        enable = true;

        # {{{ Settings
        settings =
        {
          # {{{ Devices
          devices =
          {
            fidget.id    = "FUHU63F-LN6AT7C-2H7PSDB-UMLSTE2-WM4KW4M-BBYDQ7Q-MXD5BMR-SLOWZQY";
            petridish.id = "5TQX52Q-SDYSIF3-CSXU67C-SQKM2BP-GW4KVZA-2SW7LZT-2CJNQZT-TSX7MQ2";
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
