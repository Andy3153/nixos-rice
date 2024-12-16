## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Services bundle
##

{ ... }:

{
  imports =
  [
    ./ananicy.nix
    ./flatpak.nix
    ./hamachi.nix
    ./mpd.nix
    ./openssh.nix
    ./pipewire.nix
    ./printing.nix
    ./tlp.nix
    ./udisks.nix
    ./upower.nix
    ./zerotierone.nix
  ];
}
