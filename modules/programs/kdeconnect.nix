## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## KDE Connect config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.programs.kdeconnect;
in
{
  options.custom.programs.kdeconnect.enable = lib.mkEnableOption "enables KDE Connect";
  #config.programs.kdeconnect.enable         = cfg.enable;

  config = lib.mkIf cfg.enable
  {
    programs.kdeconnect =
    {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };
  };
}
