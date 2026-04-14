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

      sysctl =
      {
        kernel.sysrq  = 244; # enable REISUB
        vm.swappiness = 10;
      };

      uefi =
      {
        enable = true;
        secure-boot.enable = true;
      };
    };
    # }}}

    # {{{ GUI
    gui =
    {
      enable                     = true;
      #gaming.enable              = true;
      rices.hyprland-rice.enable = true;
    };
    # }}}

    # {{{ Hardware
    hardware =
    {
      bluetooth =
      {
        enable = true;
        powerOnBoot = false;
      };

      #graphictablets.enable = true;
      #openrgb.enable        = true;
      #piper.enable          = true;
      thunderbolt.enable    = true;
    };
    # }}}

    # {{{ Networking
    networking.stevenblack.enable = true;
    # }}}

    # {{{ Programs
    programs =
    {
      adb.enable      = true;
      appimage.enable = true;
      direnv.enable   = true;

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
      #spicetify.enable = true;

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
          # {{{ `helix`
          "helix" =
          {
            hostname       = "helix";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "fidget-helix"
            identitiesOnly = true;
          };

          "andy3153.am-furnici.ro" =
          {
            hostname       = "andy3153.am-furnici.ro";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "fidget-helix"
            identitiesOnly = true;
          };

          "andy3153.go.ro" =
          {
            hostname       = "andy3153.go.ro";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "fidget-helix"
            identitiesOnly = true;
          };

          "andy3153.duckdns.org" =
          {
            hostname       = "andy3153.duckdns.org";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "fidget-helix"
            identitiesOnly = true;
          };
          # }}}

          # {{{ `petridish`
          "petridish" =
          {
            hostname       = "petridish";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-petridish"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-petridish -C "fidget-petridish"
            identitiesOnly = true;
          };
          # }}}

          # {{{ `sparkle`
          "sparkle" =
          {
            hostname       = "sparkle";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-sparkle"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-sparkle -C "fidget-sparkle"
            identitiesOnly = true;
          };
          # }}}

          # {{{ GitHub
          "github.com" =
          {
            hostname       = "github.com";
            user           = "git";
            identityFile   = "${homeDir}/.ssh/id_ed25519-github"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-github -C "fidget-github"
            identitiesOnly = true;
          };
          # }}}

          # {{{ GitLab
          "gitlab.com" =
          {
            hostname       = "gitlab.com";
            user           = "git";
            identityFile   = "${homeDir}/.ssh/id_ed25519-gitlab"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-gitlab -C "fidget-gitlab"
            identitiesOnly = true;
          };
          # }}}
        };
        # }}}
      };
      # }}}

      #tilp2.enable     = true;
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

      printing =
      {
        enable  = true;
        drivers = [ pkgs.brlaser ];
      };

      tlp =
      {
        enable = true;
        chargeThreshold.stop = 80;
      };

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
      docker =
      {
        enable       = true;
        enableOnBoot = false;
      };

      #libvirtd.enable  = true;
      podman.enable    = true;
    };
    # }}}

    # {{{ XDG
    xdg =
    {
      userDirs.enable = true;
    };
    # }}}

    system.stateVersion = "24.11";
  };
}
