## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## SDDM config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.gui.dm.sddm;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.gui.dm.sddm.enable = lib.mkEnableOption "enables SDDM";

  config = lib.mkIf cfg.enable
  {
    services.displayManager.sddm =
    {
      enable         = lib.mkDefault true;
      autoNumlock    = lib.mkDefault true;
      wayland.enable = lib.mkDefault true;

      settings =
      {
        Autologin =
        {
          User = mainUser;
        };
      };
    };
  };
}
