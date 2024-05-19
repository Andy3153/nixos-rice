## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## SDDM config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.gui.dm.sddm;
in
{
  options =
  {
    custom.gui.dm.sddm.enable = lib.mkEnableOption "enables SDDM";
  };

  config = lib.mkIf module.enable
  {
    services.displayManager.sddm =
    {
      enable         = true;
      autoNumlock    = true;
      #theme          = "breeze";
      wayland.enable = true;

      settings =
      {
        Autologin =
        {
          User    = "andy3153";
        };
      };
    };
  };
}
