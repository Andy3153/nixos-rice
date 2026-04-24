## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Syncthing config
##

{ config, options, lib, pkgs, ... }:

let
  cfg = config.custom.services.syncthing;

  mainUser      = config.custom.users.mainUser;
  mainUserDesc  = config.users.users.${mainUser}.description;
  mainUserGroup = config.users.users.${mainUser}.group;

  HM         = config.home-manager.users.${mainUser};
  configHome = HM.xdg.configHome;
in
{
  options.custom.services.syncthing =
  {
    enable   = lib.mkEnableOption "enables Syncthing";
    settings = options.services.syncthing.settings;
  };

  config = lib.mkIf cfg.enable
  {
    services.syncthing =
    {
      enable           = true;
      openDefaultPorts = true;
      overrideDevices  = true;
      overrideFolders  = true;

      configDir = "${configHome}/syncthing";

      group = mainUserGroup;
      user  = mainUser;

      settings =
      {
        gui.user = mainUserDesc;
      } // cfg.settings;
    };
  };
}
