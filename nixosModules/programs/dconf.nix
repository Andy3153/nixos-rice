## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Dconf config
##

{ config, lib, ... }:

let
  cfg = config.custom.programs.dconf;
in
{
  options.custom.programs.dconf.enable = lib.mkEnableOption "enables Dconf";

  config = lib.mkIf cfg.enable
    {
      programs.dconf.enable = true;
    };
}
