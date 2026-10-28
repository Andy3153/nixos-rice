## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Boot bundle
##

{ lib, ... }:

{
  imports =
  [
    ./kernel.nix
    ./loader
    ./plymouth.nix
    ./quiet.nix
    ./sysctl.nix
    ./uefi.nix
  ];

  config = if lib.versionOlder lib.version "26.11pre"
  then { boot.initrd.systemd.enable = true; }
  else { };
}
