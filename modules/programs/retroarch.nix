## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## RetroArch config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.programs.retroarch;
in
{
  options.custom.programs.retroarch.enable = lib.mkEnableOption "enables RetroArch";
  config = lib.mkIf cfg.enable
  {
    custom =
    {
      extraPackages = [ pkgs.retroarch-full ];
      nix.unfreeWhitelist =
      [
        "libretro-fbalpha2012"
        "libretro-fbneo"
        "libretro-fmsx"
        "libretro-genesis-plus-gx"
        "libretro-mame2000"
        "libretro-mame2003"
        "libretro-mame2003-plus"
        "libretro-mame2010"
        "libretro-mame2015"
        "libretro-opera"
        "libretro-picodrive"
        "libretro-snes9x"
        "libretro-snes9x2002"
        "libretro-snes9x2005"
        "libretro-snes9x2005-plus"
        "libretro-snes9x2010"
      ];
    };
  };
}
