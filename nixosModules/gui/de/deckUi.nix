## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Steam Deck UI config
##

{ config, lib, ... }:

let
  cfg       = config.custom.gui.de.deckUi;
  dmSession = config.services.displayManager.defaultSession;
  mainUser  = config.custom.users.mainUser;
in
{
  options.custom.gui.de.deckUi =
  {
    enable    = lib.mkEnableOption "enables Steam Deck UI";
    autoStart = lib.mkEnableOption "whether to autostart the Steam Deck UI";
  };

  config = lib.mkIf cfg.enable
  {
    jovian =
    {
      steam =
      {
        enable         = true;
        autoStart      = cfg.autoStart;
        desktopSession = dmSession;
        updater.splash = "bgrt";
        user           = mainUser;
      };

      steamos =
      {
        enableBluetoothConfig     = true;
        enableEarlyOOM            = true;
        enableProductSerialAccess = true;
        enableSysctlConfig        = true;

        useSteamOSConfig = lib.mkForce false;
      };
    };

    custom =
    {
      gui.dm.sddm.enable = lib.mkForce (!config.jovian.steam.autoStart);

      # {{{ Unfree package whitelist
      nix.unfreeWhitelist =
      [
        "steam-jupiter-unwrapped"
        "steamdeck-hw-theme"
      ];
      # }}}
    };
  };
}
