## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Services bundle
##

{ config, lib, pkgs, ... }:

{
  imports =
  [
    ./ananicy.nix
    ./flatpak.nix
    ./pipewire.nix
    ./printing.nix
  ];

  custom.services =
  {
    ananicy.enable  = lib.mkDefault false;
    flatpak.enable  = lib.mkDefault false;
    pipewire.enable = lib.mkDefault false;
    printing.enable = lib.mkDefault false;
  };
}
