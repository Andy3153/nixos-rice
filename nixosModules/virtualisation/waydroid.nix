## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Waydroid config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.virtualisation.waydroid;
in
{
  options =
  {
    custom.virtualisation.waydroid.enable = lib.mkEnableOption "enables Waydroid";
  };

  config = lib.mkIf module.enable
  {
    virtualisation.waydroid.enable = true;
  };
}
