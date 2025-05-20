## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Bluetooth config
##

{ config, lib, ... }:

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

  config = lib.mkIf cfg.enable
  {
    hardware.bluetooth =
    {
      enable = true;

      settings =
      {
        General =
        {
          Enable       = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };

      powerOnBoot = cfg.powerOnBoot;
    };

    services.blueman.enable = true;
  };
}
