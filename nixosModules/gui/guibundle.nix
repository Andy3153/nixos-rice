## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GUI bundle
##

{ config, lib, pkgs, ... }:

{
  imports =
  [
    ./dm/greetd.nix
    ./dm/sddm.nix
    ./wm/hyprland.nix
  ];

  custom.gui =
  {
    dm =
    {
      greetd.enable = lib.mkDefault false;
      sddm.enable   = lib.mkDefault false;
    };

    wm =
    {
      hyprland.enable = lib.mkDefault false;
    };
  };
}
