## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Syncthing config
##

{ config, options, lib, ... }:

let
  cfg = config.custom.services.syncthing;

  mainUser      = config.custom.users.mainUser;
  mainUserDesc  = config.users.users.${mainUser}.description;
  mainUserGroup = config.users.users.${mainUser}.group;

  HM      = config.home-manager.users.${mainUser};
  homeDir = HM.home.homeDirectory;
in
{
  # {{{ Options
  options.custom.services.syncthing =
  {
    enable = lib.mkEnableOption "enables Syncthing";

    configDir = lib.mkOption
    {
      type        = options.services.syncthing.configDir.type;
      default     = "${cfg.dataDir}/.config/syncthing";
      example     = options.services.syncthing.configDir.example;
      description = options.services.syncthing.configDir.description;
    };

    dataDir = lib.mkOption
    {
      type        = options.services.syncthing.dataDir.type;
      default     = homeDir;
      example     = options.services.syncthing.dataDir.example;
      description = options.services.syncthing.dataDir.description;
    };

    settings = options.services.syncthing.settings;
  };
  # }}}

  config = lib.mkIf cfg.enable
  {
    services.syncthing =
    {
      enable           = true;
      openDefaultPorts = true;
      overrideDevices  = true;
      overrideFolders  = true;

      configDir = cfg.configDir;
      dataDir   = cfg.dataDir;

      group = mainUserGroup;
      user  = mainUser;

      settings =
      {
        gui.user = mainUserDesc;
        options.urAccepted = -1; # disable usage report
      } // cfg.settings;
    };
  };
}
