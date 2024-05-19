## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Graphic tablets config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.hardware.graphictablets;
in
{
  options =
  {
    custom.hardware.graphictablets.enable = lib.mkEnableOption "enables graphic tablets";
  };

  config = lib.mkIf module.enable
  {
    hardware.opentabletdriver =
    {
      enable        = true;
      daemon.enable = true;
    };
  };
}
