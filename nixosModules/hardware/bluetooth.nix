## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Bluetooth config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.hardware.bluetooth;
in
{
  options.custom.hardware.bluetooth =
  {
    enable      = lib.mkEnableOption "enables Bluetooth";
    powerOnBoot = lib.mkOption
    {
      type        = lib.types.bool;
      default     = true;
      example     = false;
      description = "whether to power up the default Bluetooth controller on boot";
    };
  };

  config = lib.mkMerge
  [
    (lib.mkIf cfg.enable         { hardware.bluetooth.enable      = lib.mkDefault true; })
    (lib.mkIf (!cfg.powerOnBoot) { hardware.bluetooth.powerOnBoot = lib.mkDefault false; })
  ];
}
