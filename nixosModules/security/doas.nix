## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Doas config
##

{ config, lib, ... }:

let
  cfg = config.custom.security.doas;
  mainUser = config.custom.users.mainUser;
in
{
  options.custom.security.doas.enable = lib.mkOption
  {
    type        = lib.types.bool;
    default     = true;
    example     = false;
    description = "enables Doas";
  };

  config = lib.mkIf cfg.enable
  {
    security =
    {
      sudo.enable = lib.mkForce false;
      doas =
      {
        enable      = true;
        extraConfig = "permit persist setenv { WAYLAND_DISPLAY XDG_RUNTIME_DIR XAUTHORITY LANG LC_ALL } ${mainUser}";
      };
    };
  };
}
