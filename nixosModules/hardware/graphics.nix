## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Graphics config
##

{ config, lib, ... }:

let
  cfg = config.custom.hardware.graphics;
in
{
  options.custom.hardware.graphics.enable = lib.mkEnableOption "enables OpenGL";

  config = lib.mkIf cfg.enable
  {
    hardware.graphics =
    {
      enable          = lib.mkDefault true;
      #driSupport      = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };
  };
}
