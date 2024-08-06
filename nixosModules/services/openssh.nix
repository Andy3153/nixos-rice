## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## OpenSSH config
##

{ config, options, lib, ... }:

let
  cfg      = config.custom.services.openssh;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.services.openssh =
  {
    enable   = lib.mkEnableOption "enables OpenSSH";
    settings = lib.mkOption
    {
      type    = options.services.openssh.settings.type;
      default =
      {
        AllowUsers      = [ mainUser ];
        PermitRootLogin = "no";
        PrintMotd       = true;
      };
    };
  };

  config = lib.mkIf cfg.enable
  {
    services.openssh =
    {
      enable   = true;
      settings = cfg.settings;
    };
  };
}
