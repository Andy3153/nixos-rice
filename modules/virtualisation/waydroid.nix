## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Waydroid config
##

{ config, lib, ... }:

let
  cfg = config.custom.virtualisation.waydroid;
in
{
  options.custom.virtualisation.waydroid.enable = lib.mkEnableOption "enables Waydroid";
  config.virtualisation.waydroid.enable         = cfg.enable;
}
