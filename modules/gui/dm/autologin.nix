## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Autologin config
##

{ config, lib, ... }:

let
  cfg      = config.custom.gui.dm.autologin;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.gui.dm.autologin =
  {
    enable = lib.mkEnableOption "enables autologin";

    user = lib.mkOption
    {
      type        = lib.types.str;
      default     = mainUser;
      example     = "user";
      description = "user to autologin as";
    };
  };

  config = lib.mkIf cfg.enable
  {
    services.displayManager =
    {
      autoLogin =
      {
        enable = true;
        user   = cfg.user;
      };
    };
  };
}
