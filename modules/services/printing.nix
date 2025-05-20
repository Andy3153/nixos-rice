## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Printing config
##

{ config, options, lib, pkgs, ... }:

let
  cfg = config.custom.services.printing;
in
{
  options.custom.services.printing =
  {
    enable = lib.mkEnableOption "enables printing";
    drivers = lib.mkOption
    {
      type        = options.services.printing.drivers.type;
      example     = [ pkgs.brlaser ];
      description = "CUPS drivers to use";
    };
  };

  config = lib.mkIf cfg.enable
  {
    services.printing =
    {
      enable          = true;
      drivers         = cfg.drivers;
      startWhenNeeded = true;
      webInterface    = true;
    };
  };
}
