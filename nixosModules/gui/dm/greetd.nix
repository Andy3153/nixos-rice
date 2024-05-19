## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## greetd config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.gui.dm.greetd;
in
{
  options =
  {
    custom.gui.dm.greetd.enable = lib.mkEnableOption "enables greetd";
  };

  config = lib.mkIf module.enable
  {
    programs.regreet.enable = true;

    services.greetd =
    {
      enable  = true;
      restart = true;
      settings = rec
      {
        initial_session =
        {
          #command = "${pkgs.hyprland}/bin/Hyprland";
          user = "andy3153";
        };

        default_session =
        {
          command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
        };
      };
    };
  };
}
