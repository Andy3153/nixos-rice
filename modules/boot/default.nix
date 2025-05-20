## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Boot bundle
##

{ ... }:

{
  imports =
  [
    ./initrd.nix
    ./kernel.nix
    ./loader
    ./plymouth.nix
    ./quiet.nix
    ./sysctl.nix
    ./uefi.nix
  ];
}
