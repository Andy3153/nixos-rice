## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hardware bundle
##

{ ... }:

{
  imports =
    [
      ./bluetooth.nix
      ./controllers.xbox.nix
      ./graphictablets.nix
      ./i2c.nix
      ./nvidia.nix
      ./opengl.nix
      ./openrgb.nix
    ];
}
