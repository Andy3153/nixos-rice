## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Programs bundle
##

{ config, lib, pkgs, ... }:

{
  imports =
  [
    ./steam.nix
  ];
}
