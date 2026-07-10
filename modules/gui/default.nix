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
    ./de
    ./dm
    ./rices
    ./theme
    ./wm
    ./fileManagerBookmarks.nix
    ./gaming.nix
  ];

  options.custom.gui.enable = lib.mkEnableOption "enables a GUI";

  config = lib.mkIf cfg.enable
  {
    services.playerctld.enable = true;

    custom =
    {
      boot.plymouth.enable            = true;

      gui =
      {
        fileManagerBookmarks.enable = true;
        gaming.optimizations.enable = lib.mkDefault cfg.gaming.enable;
      };

      hardware.graphics.enable        = true;
      programs.dconf.enable           = true;
      services.udisks2.enable         = true;
      services.pipewire.enable        = true;

      xdg =
      {
        enable          = true;
        mime.enable     = true;
        portal.enable   = true;
        userDirs.enable = true;
      };
    };
  };
}
