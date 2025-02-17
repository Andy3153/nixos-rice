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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhwsDe32pk/LJ9ndeOM4tM8OH/erSrkza3PHTu053GV sparkle-helix"
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

  system.stateVersion = "24.11";
}
