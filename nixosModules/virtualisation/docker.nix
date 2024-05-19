## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Docker config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.virtualisation.docker;
in
{
  options =
  {
    custom.virtualisation.docker.enable = lib.mkEnableOption "enables Docker";
  };

  config = lib.mkIf module.enable
  {
    virtualisation.docker =
    {
      enable           = true;
      enableOnBoot     = true;
      autoPrune.enable = true;
    };
  };
}
