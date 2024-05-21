## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Custom NixOS modules bundle
##

{ config, lib, pkgs, ... }:

{
  imports =
  [
    ./settings.nix
    ./boot
    ./gui
    ./hardware
    ./services
    ./users
    ./virtualisation
    ./xdg.portal.nix
  ];
}
