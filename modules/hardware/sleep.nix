## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Sleep config
##
## https://www.freedesktop.org/software/systemd/man/latest/sleep.conf.d.html
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.sleep;
in
{
  options.custom.hardware.sleep =
  {
    hibernate.delayAfterSuspend = lib.mkOption
    {
      type        = lib.types.str;
      default     = "4h";
      example     = "ignore";
      description = "the amount of time the system spends in suspend mode before the system is automatically put into hibernate mode";
    };
  };

  config =
  {
    systemd.sleep.settings.Sleep =
    {
      HibernateDelaySec  = cfg.hibernate.delayAfterSuspend;
      HibernateOnACPower = false;
    };
  };
}
