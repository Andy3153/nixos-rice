## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Plymouth config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.boot.plymouth;
in
{
  options =
  {
    custom.boot.plymouth.enable = lib.mkEnableOption "enables Plymouth";
  };

  config = lib.mkIf module.enable
  {
    boot.plymouth =
    {
      enable = true;
    };
  };
}
