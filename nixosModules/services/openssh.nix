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

    authorizedKeys = lib.mkOption
    {
      type        = lib.types.anything;
      default     = "";
      description = "list of OpenSSH public keys that will be authorized to log in for the main user of the configuration";
    };

    settings = lib.mkOption
    {
      type    = options.services.openssh.settings.type;
      default =
      {
        AllowUsers      = [ mainUser ];
        PermitRootLogin = "no";
        PrintMotd       = true;
        X11Forwarding   = false;
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

    users.users.${mainUser}.openssh.authorizedKeys.keys = cfg.authorizedKeys;
  };
}
