## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## greetd config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.gui.dm.greetd;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.gui.dm.greetd.enable = lib.mkEnableOption "enables greetd";

  config = lib.mkIf cfg.enable
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
          user = mainUser;
        };

        default_session =
        {
          command = "${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.regreet}/bin/regreet";
        };
      };
    };
  };
}
