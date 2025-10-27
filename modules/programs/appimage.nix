## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## AppImage config
##

{ config, lib, ... }:

let
  cfg = config.custom.programs.appimage;
in
{
  options.custom.programs.appimage.enable = lib.mkEnableOption "enables AppImage";
  config = lib.mkIf cfg.enable
  {
    programs.appimage =
    {
      enable = true;
      binfmt = true;
    };
  };
}
