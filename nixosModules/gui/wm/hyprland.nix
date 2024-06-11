## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hyprland config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.gui.wm.hyprland;
in
{
  options.custom.gui.wm.hyprland.enable = lib.mkEnableOption "enables Hyprland";

  config = lib.mkIf cfg.enable
  {
    custom.gui.dm.sddm.enable = lib.mkDefault true;
    custom.xdg.portal.enable  = lib.mkDefault true;
    programs.hyprland.enable  = lib.mkDefault true;

    nix.settings = # Enable Hyprland Cachix
    {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    services =
    {
      displayManager.defaultSession = lib.mkDefault "hyprland";

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
      xdg-desktop-portal-gtk
    ];

    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      wayland.windowManager.hyprland =
      {
        enable          = lib.mkDefault true;
        xwayland.enable = lib.mkDefault true;
        extraConfig     = " ";
      };

      xdg.portal =
      {
        extraPortals = config.xdg.portal.extraPortals;

        config.common.default =
        [
          "hyprland"
          "gtk"
        ];
      };
    };
    # }}}
  };
}
