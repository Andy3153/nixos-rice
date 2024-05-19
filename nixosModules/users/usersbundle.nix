## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Users bundle
##

{ config, lib, pkgs, ... }:

{
  imports =
  [
    ./andy3153.nix
    ./bot.nix
  ];

  custom.users =
  {
    andy3153.enable = lib.mkDefault false;
    bot.enable      = lib.mkDefault false;
  };
}
