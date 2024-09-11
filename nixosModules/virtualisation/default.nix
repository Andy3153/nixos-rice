## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Virtualisation bundle
##

{ ... }:

{
  imports =
  [
    ./binfmt.nix
    ./distrobox.nix
    ./docker.nix
    ./libvirtd.nix
    ./waydroid.nix
  ];
}
