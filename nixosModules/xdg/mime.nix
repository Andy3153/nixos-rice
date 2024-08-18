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
      enable              = cfg.enable;
      addedAssociations   = cfg.defaultApplications;
      defaultApplications = cfg.defaultApplications;
    };

    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      xdg.mime.enable = cfg.enable;
      xdg.mimeApps =
      {
        enable              = cfg.enable;
        associations.added  = cfg.defaultApplications;
        defaultApplications = cfg.defaultApplications;
      };
    };
    # }}}
  };
}
