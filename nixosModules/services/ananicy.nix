## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Ananicy config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.services.ananicy;
in
{
  options =
  {
    custom.services.ananicy.enable = lib.mkEnableOption "enables Ananicy";
  };

  config = lib.mkIf module.enable
  {
    services.ananicy =
    {
      enable  = true;
      package = pkgs.ananicy-cpp;
    };
  };
}
