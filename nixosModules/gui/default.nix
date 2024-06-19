## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GUI bundle
##

{ config, lib, ... }:

let
  cfg = config.custom.gui;
in
{
  imports =
  [
    ./dm
    ./rices
    ./theme
    ./wm
    ./gaming.nix
  ];

  options.custom.gui.enable = lib.mkEnableOption "enables a GUI";

  config = lib.mkIf cfg.enable
  {
    custom =
    {
      boot.plymouth.enable = lib.mkDefault true;

      gui =
      {
        gaming.enable               = lib.mkDefault false;
        gaming.optimizations.enable = lib.mkDefault cfg.gaming.enable;
      };

      hardware.opengl.enable   = lib.mkDefault true;
      programs.dconf.enable    = lib.mkDefault true;
      services.udisks2.enable  = lib.mkDefault true;
      services.pipewire.enable = lib.mkDefault true;

      xdg =
      {
        enable        = lib.mkDefault true;
        portal.enable = lib.mkDefault true;
        mime.enable = lib.mkDefault true;
      };
    };
  };
}
