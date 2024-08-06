## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `ember`
##
## Raspberry Pi 4
##

{ lib, ... }:

{
  imports =
  [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  custom =
  {
    # {{{ Boot
    boot.loader.timeout = 2; #extlinux is weird af
    # }}}

    # {{{ Programs
    programs =
    {
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

      # {{{ Git
      git =
      {
        enable    = true;
        userName  = "Andy3153";
        userEmail = "andy3153@protonmail.com";
      };
      # }}}
    };
    # }}}

    # {{{ Services
    services.flatpak.enable = lib.mkForce false;
    # }}}

    # {{{ Users
    users.mainUser = "andy3153";
    # }}}
  };

  system.stateVersion = "24.05";
}
