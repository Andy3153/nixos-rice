## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Bot user (sample user) config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.users.bot;
in
{
  options =
  {
    custom.users.bot.enable = lib.mkEnableOption "enables Bot user (sample user)";
  };

  config = lib.mkIf module.enable
  {
    users =
    {
      groups.bot =
      {
        members = [ "bot" ];
      };

      users.bot =
      {
        description     = "Bot";
        initialPassword = "sdfsdf";
        isNormalUser    = true;
        group           = "bot";
      };
    };
  };
}
