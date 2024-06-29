## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## TLP config
##

{ config, lib, ... }:

let
  cfg = config.custom.services.tlp;
in
{
  options.custom.services.tlp =
  {
    enable = lib.mkEnableOption "enables TLP";

    chargeThreshold =
    {
      start = lib.mkOption
      {
        type        = lib.types.int;
        default     = 100;
        example     = 75;
        description = "below what percentage to start charging the battery";
      };

      stop = lib.mkOption
      {
        type        = lib.types.int;
        default     = 100;
        example     = 80;
        description = lib.literalExpression
        ''
          above what percentage to stop charging the battery

          warning: some laptops silently ignore threshold values other than some manufacturer-chosen values (ex.: ASUS: 40, 60, 80)
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable
  {
    services.tlp =
    {
      enable = lib.mkDefault true;
      settings =
      {
        START_CHARGE_THRESH_BAT0 = cfg.chargeThreshold.start;
        STOP_CHARGE_THRESH_BAT0  = cfg.chargeThreshold.stop;

        START_CHARGE_THRESH_BAT1 = cfg.chargeThreshold.start;
        STOP_CHARGE_THRESH_BAT1  = cfg.chargeThreshold.stop;

        BAY_POWEROFF_ON_AC = 1;
      };
    };
  };
}
