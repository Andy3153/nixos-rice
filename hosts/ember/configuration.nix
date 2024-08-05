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
    programs =
    {
      zsh =
      {
        enable = true;
      };
    };

    services.flatpak.enable = lib.mkForce false;

    users.mainUser = "andy3153";
  };

  users.users =
  {
    root.initialPassword = "sdfsdf";
  };
}
