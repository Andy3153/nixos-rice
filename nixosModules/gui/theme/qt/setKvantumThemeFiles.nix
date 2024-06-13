## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Set Kvantum theme files options
##

{ config, lib, ... }:

let
  cfg              = config.custom.gui.theme.qt;
  kvantumThemePkg  = cfg.style.kvantum.theme.package;
  kvantumThemeName = cfg.style.kvantum.theme.name;
in
{
  config = lib.mkIf (cfg.style.kvantum.package != null)
  {
    custom.gui.theme.qt.style.kvantum =
    {
      kvconfigFile = "${kvantumThemePkg}/share/Kvantum/${kvantumThemeName}/${kvantumThemeName}.kvconfig";
      svgFile      = "${kvantumThemePkg}/share/Kvantum/${kvantumThemeName}/${kvantumThemeName}.kvconfig";
    };
  };
}
