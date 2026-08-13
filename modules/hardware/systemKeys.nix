## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## System keys config
##
## https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.systemKeys;

  powerKeyType = lib.types.enum
  [
    "factory-reset"          "halt"     "hibernate"
    "hybrid-sleep"           "ignore"   "kexec"
    "lock"                   "poweroff" "reboot"
    "secure-attention-key"   "sleep"    "suspend"
    "suspend-then-hibernate"
  ];
in
{
  options.custom.hardware.systemKeys =
  {
    lid = lib.mkOption
    {
      type        = powerKeyType;
      default     = "suspend-then-hibernate";
      example     = "ignore";
      description = "how the lid switch should be handled";
    };

    power = lib.mkOption
    {
      type        = powerKeyType;
      default     = "poweroff";
      example     = "ignore";
      description = "how the power key should be handled";
    };

    powerLongPress = lib.mkOption
    {
      type        = powerKeyType;
      default     = "ignore";
      example     = "suspend-then-hibernate";
      description = "how the power key should be handled when held pressed";
    };
  };

  config =
  {
    services.logind.settings.Login =
    {
      HandleLidSwitch              = cfg.lid;
      HandleLidSwitchDocked        = cfg.lid;
      HandleLidSwitchExternalPower = cfg.lid;

      HandlePowerKey          = cfg.power;
      HandlePowerKeyLongPress = cfg.powerLongPress;
    };
  };
}
