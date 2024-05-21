## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hardware bundle
##

{ config, lib, pkgs, ... }:

{
  imports =
  [
    ./bluetooth.nix
    ./controllers.xbox.nix
    ./graphictablets.nix
    ./i2c.nix
    ./nvidia.nix
    ./nvidia.prime.nix
    ./opengl.nix
    ./openrgb.nix
  ];

  custom.hardware =
  {
    bluetooth.enable        = lib.mkDefault false;
    graphictablets.enable   = lib.mkDefault false;
    i2c.enable              = lib.mkIf config.custom.hardware.openrgb.enable true;
    nvidia.enable           = lib.mkIf config.custom.hardware.nvidia.prime.enable true;
    nvidia.prime.enable     = lib.mkDefault false;
    opengl.enable           = lib.mkDefault false;
    openrgb.enable          = lib.mkDefault false;
    controllers.xbox.enable = lib.mkDefault false;
  };
}
