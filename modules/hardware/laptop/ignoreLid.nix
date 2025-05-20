## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Ignore laptop lid config
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.laptop.ignoreLid;
in
{
  options.custom.hardware.laptop.ignoreLid = lib.mkEnableOption "whether to ignore the laptop lid sensor";

  config = lib.mkIf cfg
  {
    services.logind =
    {
      lidSwitch              = "ignore";
      lidSwitchDocked        = "ignore";
      lidSwitchExternalPower = "ignore";
    };
  };
}
