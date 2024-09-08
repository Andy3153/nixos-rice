## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `ember`
##
## Raspberry Pi 4
##

{ lib, ... }:

{
  custom =
  {
    # {{{ Boot
    boot =
    {
      loader.timeout       = 2; #extlinux is weird af
      sysctl.vm.swappiness = 40;
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJ1yAeBhLPqvKKsDqizlk+pBEFOsPYWEgfGJqN2LJ71 sparkle-ember"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMfErijXq5GrzIrN6BP3AV2vAg2Y52+PB2JECYp/d5Q6 hope-ember"
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

  system.stateVersion = "24.05";
}
