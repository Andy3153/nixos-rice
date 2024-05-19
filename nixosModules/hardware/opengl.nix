## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## OpenGL config
##

{ config, lib, pkgs, ... }:

let
  module = config.custom.hardware.opengl;
in
{
  options =
  {
    custom.hardware.opengl.enable = lib.mkEnableOption "enables OpenGL";
  };

  config = lib.mkIf module.enable
  {
    hardware.opengl =
    {
      enable          = true;
      driSupport      = true;
      driSupport32Bit = true;
    };
  };
}
