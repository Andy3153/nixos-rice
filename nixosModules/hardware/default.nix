## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hardware bundle
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware;
in
{
  imports =
  [
    ./bluetooth.nix
    ./controllers.xbox.nix
    ./graphics.nix
    ./graphictablets.nix
    ./gpuDrivers.nix
    ./i2c.nix
    ./nvidia.nix
    ./openrgb.nix
  ];

  options.custom.hardware.isLaptop = lib.mkEnableOption "enable this if host is a laptop";

  config = lib.mkMerge
  [
    (lib.mkIf cfg.isLaptop # Laptop sane defaults
    {
      hardware.bluetooth.enable = true;

      services =
      {
        tlp.enable    = lib.mkDefault true;
        upower.enable = lib.mkDefault true;
      };
    })
  ];
}
