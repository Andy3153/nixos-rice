## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## XDG MIME config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.xdg.mime;
in
{
  options.custom.xdg.mime =
  {
    enable = lib.mkEnableOption "enables XDG MIME";

    defaultApplications = lib.mkOption
    {
      type        = with lib.types; attrsOf (coercedTo (either (listOf str) str) (x: lib.concatStringsSep ";" (lib.toList x)) str);
      default     = 0;
      example     = 5;
      description = "sets the default applications for given mimetypes";
    };
  };

  config =
  {
    xdg.mime =
    {
      enable              = lib.mkDefault cfg.enable;
      defaultApplications = lib.mkDefault cfg.defaultApplications;
    };
  };
}
