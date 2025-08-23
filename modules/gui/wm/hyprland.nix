## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hyprland config
##

{ config, lib, pkgs, ... }:

let
  cfg      = config.custom.gui.wm.hyprland;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.gui.wm.hyprland.enable = lib.mkEnableOption "enables Hyprland";

  config = lib.mkIf cfg.enable
  {
    custom.gui.dm.sddm.enable = true;
    custom.xdg.portal.enable  = true;
    programs.hyprland.enable  = true;

    nix.settings = # Enable Hyprland Cachix
    {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    services =
    {
      displayManager.defaultSession = "hyprland";

      greetd.settings =
      {
        initial_session =
        {
          command = lib.getExe pkgs.hyprland;
        };
      };
    };

    xdg.portal.extraPortals = with pkgs;
    [
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      xdg.portal =
      {
        extraPortals = config.xdg.portal.extraPortals;

        config.common.default =
        [
          "hyprland"
          "kde"
          "gtk"
        ];
      };
    };
    # }}}
  };
}
