## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GUI bundle
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.gui;
in
{
  imports =
  [
    ./dm
    ./wm
  ];

  options.custom.gui.enable = lib.mkEnableOption "enables a GUI";

  config = lib.mkIf cfg.enable
  {
    custom.gui =
    {
      dm.sddm.enable     = lib.mkDefault true;
      wm.hyprland.enable = lib.mkDefault true;
    };
  };
}
