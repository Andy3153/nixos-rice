## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Java config
##

{ config, lib, ... }:

let
  cfg = config.custom.programs.java;
in
{
  options.custom.programs.java.enable = lib.mkEnableOption "enables Java";

  config = lib.mkIf cfg.enable
    {
      programs.java.enable = true;
    };
}
