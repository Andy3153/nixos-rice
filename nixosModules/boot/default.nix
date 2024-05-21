## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Boot bundle
##

{ config, lib, pkgs, ... }:

{
  imports =
  [
    ./plymouth.nix
    ./quiet.nix
    ./reisub.nix
  ];

  custom.boot =
  {
    plymouth.enable = lib.mkDefault false;
    quiet           = lib.mkIf config.custom.boot.plymouth.enable true;
    reisub.enable   = lib.mkDefault false;
  };
}
