## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Sysctl config
##

{ config, lib, ... }:

let
  cfg = config.custom.boot.sysctl;
in
{
  options.custom.boot.sysctl =
  {
    kernel =
    {
      sysrq = lib.mkOption
      {
        type        = lib.types.int;
        example     = 244;
        description = "bitmask to change behavior of Magic SysRq key (ex.: 244 enables the REISUB sequence)";
      };
    };

    swappiness = lib.mkOption
    {
      type        = lib.types.int;
      default     = 60;
      example     = 30;
      description = "what swappiness value should be used";
    };
  };

  config.boot.kernel.sysctl =
  {
    "kernel.sysrq"  = cfg.kernel.sysrq;
    "vm.swappiness" = cfg.swappiness;
  };
}
