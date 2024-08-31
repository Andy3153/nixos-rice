## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Laptop config
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.isLaptop;
in
{
  options.custom.hardware.isLaptop = lib.mkEnableOption "enable this if host is a laptop";

  config = lib.mkIf cfg
  {
    custom =
    {
      hardware.bluetooth.enable = true;

      services =
      {
        tlp.enable    = true;
        upower.enable = true;
      };
    };
  };
}
