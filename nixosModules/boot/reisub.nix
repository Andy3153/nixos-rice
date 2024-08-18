## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## REISUB config
##

{ config, lib, ... }:

let
  cfg = config.custom.boot.reisub;
in
{
  options.custom.boot.reisub.enable = lib.mkEnableOption "enables REISUB";

  config = lib.mkIf cfg.enable
  {
    custom.boot.sysctl.kernel.sysrq = lib.mkDefault 244;
  };
}
