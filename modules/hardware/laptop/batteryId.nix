## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Battery ID config
##

{ lib, ... }:

{
  options.custom.hardware.laptop.batteryId = lib.mkOption
  {
    type        = lib.types.nullOr lib.types.str;
    default     = null;
    example     = "BAT0";
    description = "laptop battery id";
  };
}
