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
}
