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
    ./wm
    ./apps.nix
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
        apps.enable        = lib.mkDefault true;
        gaming.enable      = lib.mkDefault false;
        wm.hyprland.enable = lib.mkDefault true;
      };

      hardware.opengl.enable  = lib.mkDefault true;
      programs.dconf.enable   = lib.mkDefault true;
      services.udisks2.enable = lib.mkDefault true;

      xdg =
      {
        portal.enable = lib.mkDefault true;
        mime.defaultApplications =
        {
          "text/plain"      = "neovide.desktop";
          "text/html"       = "io.gitlab.librewolf-community.desktop";
          "application/pdf" = "org.pwmt.zathura.desktop";
        };
      };
    };
  };
}
