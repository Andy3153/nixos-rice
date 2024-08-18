## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## XDG MIME config
##

{ config, options, lib, ... }:

let
  cfg = config.custom.xdg.mime;
in
{
  options.custom.xdg.mime =
  {
    enable = lib.mkEnableOption "enables XDG MIME";

    defaultApplications = lib.mkOption
    {
      type        = options.xdg.mime.defaultApplications.type;
      default     = { };
      description = "sets the default applications for given mimetypes";
    };
  };

  config =
  {
    xdg.mime =
    {
      enable              = lib.mkDefault cfg.enable;
      addedAssociations   = lib.mkDefault cfg.defaultApplications;
      defaultApplications = lib.mkDefault cfg.defaultApplications;
    };

    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      xdg.mime.enable = lib.mkDefault cfg.enable;
      xdg.mimeApps =
      {
        enable              = lib.mkDefault cfg.enable;
        associations.added  = lib.mkDefault cfg.defaultApplications;
        defaultApplications = lib.mkDefault cfg.defaultApplications;
      };
    };
    # }}}
  };
}
