## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Docker config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.virtualisation.docker;
in
{
  options.custom.virtualisation.docker.enable = lib.mkEnableOption "enables Docker";

  config = lib.mkIf cfg.enable
  {
    virtualisation.docker =
    {
      enable           = lib.mkDefault true;
      enableOnBoot     = lib.mkDefault true;
      autoPrune.enable = lib.mkDefault true;
    };
  };
}
