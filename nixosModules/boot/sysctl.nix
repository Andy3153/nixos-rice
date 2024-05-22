## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Sysctl config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.boot.sysctl;
in
{
  options.custom.boot.sysctl.swappiness = lib.mkOption
  {
    type        = lib.types.int;
    default     = 60;
    example     = 30;
    description = "what swappiness value should be used";
  };

  config.boot.kernel.sysctl =
  {
    "vm.swappiness" = cfg.swappiness;
  };
}
