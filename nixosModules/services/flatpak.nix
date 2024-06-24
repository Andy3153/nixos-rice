## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Flatpak config
##

{ config, lib, ... }:

let
  cfg      = config.custom.services.flatpak;

  mainUser = config.custom.users.mainUser;
  HM       = config.home-manager.users.${mainUser};
  homeDir  = HM.home.homeDirectory;

  gtkTheme = config.custom.gui.theme.gtk.name;

  # {{{ Default packages
  defaultPackages =
  [
    "com.github.tchx84.Flatseal"         # Base-System
  ];
  # }}}

  # {{{ Package options
  packageOptions = _:
  {
    options =
    {
      appId = lib.mkOption
      {
        type        = lib.types.str;
        description = "the app ID of the app to install";
      };

      commit = lib.mkOption
      {
        type        = lib.types.nullOr lib.types.str;
        default     = null;
        description = "hash of the app commit to install";
      };

      origin = lib.mkOption
      {
        type        = lib.types.str;
        default     = "flathub";
        description = "repository origin (default: flathub)";
      };
    };
  };
  # }}}
in
{
  options.custom.services.flatpak =
  {
    enable   = lib.mkEnableOption "enables Flatpak";
    packages = lib.mkOption
    {
      type        = with lib.types; listOf (coercedTo str (appId: { inherit appId; }) (submodule packageOptions));
      default     = [ ];
      description = "declares a list of applications to install";
    };
  };

  config = lib.mkIf cfg.enable
  {
    services.flatpak =
    {
      enable   = true;
      packages = defaultPackages ++ cfg.packages;

      update.auto =
      {
        enable     = true;
        onCalendar = "daily";
      };

      overrides.global =
      {
        Context =
        {
          filesystems =
          [
            "${homeDir}/.icons:ro"
            "${homeDir}/.local/share/fonts:ro"
            "${homeDir}/.local/share/icons:ro"
            "${homeDir}/.local/share/themes:ro"
            "/nix/store:ro"
          ];
        };

        Environment =
        {
          GTK_THEME    = gtkTheme;
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      };
    };
  };
}
