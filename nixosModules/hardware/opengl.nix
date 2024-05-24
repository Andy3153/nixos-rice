## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## OpenGL config
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.opengl;
in
{
  options.custom.hardware.opengl.enable = lib.mkEnableOption "enables OpenGL";

  config = lib.mkIf cfg.enable
  {
    hardware.opengl =
    {
      enable          = lib.mkDefault true;
      driSupport      = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;
    };
  };
}
