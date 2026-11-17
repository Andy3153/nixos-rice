## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Accounts email config
##

{ config, lib, ... }:

let
  cfg      = config.custom.accounts.email;
  mainUser = config.custom.users.mainUser;
  userName = config.users.users.${mainUser}.description;
in
{
  options.custom.accounts.email = lib.mkOption
  {
    type = lib.types.anything;

    default =
    {
      default =
      {
        address  = lib.mkIf (mainUser == "andy3153") "andy3153@protonmail.com";
        realName = userName;
        primary  = true;
      };
    };

    description = "email addresses";
  };

  config =
  {
    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      accounts.email.accounts = cfg;
    };
    # }}}
  };
}
