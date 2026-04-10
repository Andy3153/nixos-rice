## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## XDG User Directories config
##

{ config, lib, ... }:

let
  cfg       = config.custom.xdg.userDirs;
  mainUser  = config.custom.users.mainUser;
  HM        = config.home-manager.users.${mainUser};
  homeDir   = HM.home.homeDirectory;
  cacheHome = HM.xdg.cacheHome;
  dataHome  = HM.xdg.dataHome;
in
{
  options.custom.xdg.userDirs =
  {
    enable = lib.mkEnableOption "enables management of XDG User Directories";

    desktop = lib.mkOption
    {
      type        = lib.types.anything;
      default     = "${cacheHome}/xdg_desktop_folder";
      description = "The Desktop directory.";
    };

    documents = lib.mkOption
    {
      type        = lib.types.anything;
      default     = "${homeDir}/docs";
      description = "The Documents directory.";
    };

    download = lib.mkOption
    {
      type        = lib.types.anything;
      default     = "${homeDir}/downs";
      description = "The Download directory.";
    };

    music = lib.mkOption
    {
      type        = lib.types.anything;
      default     = "${homeDir}/music";
      description = "The Music directory.";
    };

    pictures = lib.mkOption
    {
      type        = lib.types.anything;
      default     = "${homeDir}/pics";
      description = "The Pictures directory.";
    };

    publicShare = lib.mkOption
    {
      type        = lib.types.anything;
      default     = "${dataHome}/xdg_public_folder";
      description = "The Public share directory.";
    };

    templates = lib.mkOption
    {
      type        = lib.types.anything;
      default     = "${dataHome}/xdg_templates_folder";
      description = "The Templates directory.";
    };

    videos = lib.mkOption
    {
      type        = lib.types.anything;
      default     = "${homeDir}/vids";
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
        enable              = true;
        createDirectories   = true;
        setSessionVariables = true;

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
