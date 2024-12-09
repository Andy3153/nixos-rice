## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## MangoHud config
##

{ config, lib, pkgs, ... }:

let
  cfg                   = config.custom.programs.mangohud;

  mainUser              = config.custom.users.mainUser;
  HM                    = config.home-manager.users.${mainUser};
  mkOutOfStoreSymlink   = HM.lib.file.mkOutOfStoreSymlink;

  homeDir               = HM.home.homeDirectory;
  hyprlandRiceConfigDir = "${homeDir}/src/hyprland/hyprland-rice/dotconfig";
in
{
  options.custom.programs.mangohud =
  {
    enable              = lib.mkEnableOption "enables MangoHud";
    enableCustomConfigs = lib.mkEnableOption "enable my custom configs";
  };

  config = lib.mkIf cfg.enable
  {
    custom.extraPackages = with pkgs; [ mangohud ];

  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    # {{{ Config files
    xdg.configFile = lib.mkIf cfg.enableCustomConfigs
    {
      "MangoHud".source = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/MangoHud";
    };
    # }}}
  };
  # }}}
  };
}
