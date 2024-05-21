## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## greetd config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.gui.dm.greetd;
in
{
  options.custom.gui.dm.greetd.enable = lib.mkEnableOption "enables greetd";

  config = lib.mkIf cfg.enable
  {
    programs.regreet.enable = lib.mkDefault true;

    services.greetd =
    {
      enable  = lib.mkDefault true;
      restart = lib.mkDefault true;
      settings = lib.mkDefault rec
      {
        initial_session =
        {
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
