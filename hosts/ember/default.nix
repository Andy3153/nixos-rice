## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## `ember` host bundle
##

{ ... }:

{
  imports =
  [
    ../../modules
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
