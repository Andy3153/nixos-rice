## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## XDG User Directories config
##

{ config, lib, ... }:

let
  cfg     = config.custom.xdg.userDirs;
  homeDir = config.home-manager.users.${config.custom.users.mainUser}.home.homeDirectory;
in
{
  options.custom.xdg.userDirs =
  {
    enable = lib.mkEnableOption "enables management of XDG User Directories";

    desktop = lib.mkOption
    {
      type        = lib.types.nullOr (lib.types.coercedTo lib.types.path builtins.toString lib.types.str);
      default     = "${homeDir}/Desktop";
      description = "The Desktop directory.";
    };

    documents = lib.mkOption
    {
      type        = lib.types.nullOr (lib.types.coercedTo lib.types.path builtins.toString lib.types.str);
      default     = "${homeDir}/Documents";
      description = "The Documents directory.";
    };

    download = lib.mkOption
    {
      type        = lib.types.nullOr (lib.types.coercedTo lib.types.path builtins.toString lib.types.str);
      default     = "${homeDir}/Download";
      description = "The Download directory.";
    };

    music = lib.mkOption
    {
      type        = lib.types.nullOr (lib.types.coercedTo lib.types.path builtins.toString lib.types.str);
      default     = "${homeDir}/Music";
      description = "The Music directory.";
    };

    pictures = lib.mkOption
    {
      type        = lib.types.nullOr (lib.types.coercedTo lib.types.path builtins.toString lib.types.str);
      default     = "${homeDir}/Pictures";
      description = "The Pictures directory.";
    };

    publicShare = lib.mkOption
    {
      type        = lib.types.nullOr (lib.types.coercedTo lib.types.path builtins.toString lib.types.str);
      default     = "${homeDir}/Public";
      description = "The Public share directory.";
    };

    templates = lib.mkOption
    {
      type        = lib.types.nullOr (lib.types.coercedTo lib.types.path builtins.toString lib.types.str);
      default     = "${homeDir}/Templates";
      description = "The Templates directory.";
    };

    videos = lib.mkOption
    {
      type        = lib.types.nullOr (lib.types.coercedTo lib.types.path builtins.toString lib.types.str);
      default     = "${homeDir}/Videos";
      description = "The Videos directory.";
    };
  };

  config = lib.mkIf cfg.enable
  {
    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      xdg.userDirs =
      {
        enable            = lib.mkDefault true;
        createDirectories = lib.mkDefault true;

        desktop           = cfg.desktop;
        documents         = cfg.documents;
        download          = cfg.download;
        music             = cfg.music;
        pictures          = cfg.pictures;
        publicShare       = cfg.publicShare;
        templates         = cfg.templates;
        videos            = cfg.videos;
      };
    };
    # }}}
  };
}
