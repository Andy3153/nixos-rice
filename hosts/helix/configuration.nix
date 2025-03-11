## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `helix`
##
## Lenovo Ideapad 320
##

{ lib, ... }:

{
  custom =
  {
    # {{{ Boot
    boot =
    {
      sysctl.vm.swappiness = 30;

      uefi =
      {
        enable = true;
        secure-boot.enable = true;
      };
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
      flatpak.enable = lib.mkForce false;

      # {{{ OpenSSH
      openssh =
      {
        enable         = true;
        authorizedKeys =
        [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPr4Tm7o9ZOI6ywso8Cp0uLXuIIcB1i9KBlWTAVVHwef sparkle-helix"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKtrj7n4JHufi1aQ3LvGpSrHLEH973bQepAYE9jwQYj brisk-helix"
        ];

        settings =
        {
          PasswordAuthentication = false;
          X11Forwarding          = true;
        };
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
  };

  # {{{ Btrbk instances
  services.btrbk.instances =
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

          subvolume."root".snapshot_create = "onchange";
          subvolume."home".snapshot_create = "onchange";
        };
      };
    };
    # }}}
  };
  # }}}

  system.stateVersion = "24.11";
}
