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
      default     = "suspend";
      example     = "ignore";
      description = "laptop lid behavior";
    };

    power = lib.mkOption
    {
      type        = powerKeyType;
      default     = "poweroff";
      example     = "ignore";
      description = "power key behavior";
    };

    powerLongPress = lib.mkOption
    {
      type        = powerKeyType;
      default     = "ignore";
      example     = "sleep";
      description = "power key behavior when held pressed";
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
