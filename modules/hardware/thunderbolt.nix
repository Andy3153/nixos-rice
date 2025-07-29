## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Thunderbolt config
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.thunderbolt;
in
{
  options.custom.hardware.thunderbolt.enable = lib.mkEnableOption "enables Thunderbolt";
  config.services.hardware.bolt.enable       = cfg.enable;
}
