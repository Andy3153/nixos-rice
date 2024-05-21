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
}
