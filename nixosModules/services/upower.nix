## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## UPower config
##

{ config, options, lib, ... }:

let
  cfg = config.custom.services.upower;
in
{
  options.custom.services.upower =
  {
    enable = lib.mkEnableOption "enables UPower";

    criticalAction = lib.mkOption
    {
      type        = options.services.upower.criticalPowerAction.type;
      default     = "HybridSleep";
      example     = "PowerOff";
      description = "action to take when `percent.criticalAction` has been reached";
    };

    percent =
    {
      low = lib.mkOption
      {
        type        = options.services.upower.percentageLow.type;
        default     = 15;
        example     = 20;
        description = "battery percentage that's considered low";
      };

      critical = lib.mkOption
      {
        type        = options.services.upower.percentageCritical.type;
        default     = 5;
        example     = 10;
        description = "battery percentage that's considered critical";
      };

      criticalAction = lib.mkOption
      {
        type        = options.services.upower.percentageAction.type;
        default     = 5;
        example     = 10;
        description = "battery percentage at which UPower takes action (from `criticalAction`)";
      };
    };
  };

  config = lib.mkIf cfg.enable
  {
    services.upower =
    {
      enable                 = true;
      criticalPowerAction    = cfg.criticalAction;
      ignoreLid              = false;

      usePercentageForPolicy = true;
      percentageLow          = cfg.percent.low;
      percentageCritical     = cfg.percent.critical;
      percentageAction       = cfg.percent.criticalAction;
    };
  };
}
