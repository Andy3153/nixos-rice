## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Boot bundle
##

{ ... }:

{
  imports =
  [
    ./loader
    ./kernel.nix
    ./plymouth.nix
    ./quiet.nix
    ./reisub.nix
    ./sysctl.nix
    ./uefi.nix
  ];

  boot.initrd.systemd.enable = true;
}
