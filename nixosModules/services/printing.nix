## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Printing config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.services.printing;
in
{
  options =
  {
    custom.services.printing.enable = lib.mkEnableOption "enables printing";
  };

  config = lib.mkIf module.enable
  {
    services.printing =
    {
      enable          = true;
      startWhenNeeded = true;
      webInterface    = true;
    };
  };
}
