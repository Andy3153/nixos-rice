## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hamachi config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.services.hamachi;
in
{
  options.custom.services.hamachi.enable = lib.mkEnableOption "enables Hamachi";

  config = lib.mkIf cfg.enable
  {
    services.logmein-hamachi.enable = true;
    custom =
    {
      extraPackages       = [ pkgs.haguichi ]; # Hamachi-GUI
      nix.unfreeWhitelist = [ "logmein-hamachi" ];
    };
  };
}
