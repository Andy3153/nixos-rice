## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hyprland config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.gui.wm.hyprland;
in
{
  options =
  {
    custom.gui.wm.hyprland.enable = lib.mkEnableOption "enables Hyprland";
  };

  config = lib.mkIf module.enable
  {
    custom.xdg.portal.enable = true;
    programs.hyprland.enable = true;

    nix.settings = # Enable Hyprland Cachix
    {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    services =
    {
      displayManager.defaultSession = "hyprland";

      greetd.settings = rec
      {
        initial_session =
        {
          command = "${pkgs.hyprland}/bin/Hyprland";
        };
      };
    };
  };
}
