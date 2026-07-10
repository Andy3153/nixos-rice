## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## File manager bookmarks config
##

{ config, lib, pkgs, ... }:

# {{{ Variables
let
  cfg = config.custom.gui.fileManagerBookmarks;

  mainUser = config.custom.users.mainUser;

  HM          = config.home-manager.users.${mainUser};
  homeDir     = HM.home.homeDirectory;
  configHome  = HM.xdg.configHome;
  dataHome    = HM.xdg.dataHome;
  xdgUserDirs = HM.xdg.userDirs;

  btrfsSubvols  = config.custom.filesystems.disk.main.partitions.main.subvolumes;
  btrfsRootPath = btrfsSubvols."/".mountpoint;
  snapshotsPath = btrfsSubvols."/snapshots".mountpoint;
  persistPath   = btrfsSubvols."/persist".mountpoint;

  xdgFolderTitle = name: builtins.baseNameOf (xdgUserDirs.${name});

  mkFolder = path: icon:
  {
    icon  = if (icon == null || icon == "") then "inode-directory" else "${icon}";
    title = ''${builtins.baseNameOf path}'';
    uri   = ''file://${path}'';
  };

  mkXdgFolder = name:
  {
    icon  = "folder-${lib.strings.toLower name}";
    title = ''${xdgFolderTitle name}'';
    uri   = ''file://${xdgUserDirs.${name}}'';
  };
in
# }}}
{
  # {{{ Options
  options.custom.gui.fileManagerBookmarks =
  {
    enable     = lib.mkEnableOption "enables file manager bookmarks managing.";
    gtk.enable = lib.mkEnableOption "enables file manager bookmarks managing in GTK programs.";

    # {{{ Bookmarks
    bookmarks = lib.mkOption
    {
      # {{{ Type
      type = lib.types.listOf (lib.types.submodule
      {
        options =
        {
          icon = lib.mkOption
          {
            type = lib.types.str;
            default = "inode-directory";
            example = "folder-downloads";
            description = "icon name for the bookmark (only used by KDE's bookmarks).";
          };

          title = lib.mkOption
          {
            type = lib.types.str;
            example = ''${xdgFolderTitle "download"}'';
            description = "display name.";
          };

          uri = lib.mkOption
          {
            type = lib.types.str;
            description = "URI for the bookmark (ex.: file://... or sftp://...).";
            example = ''file://${xdgUserDirs.download}'';
          };
        };
      });
      # }}}

      # {{{ Default
      default =
      [
        (mkFolder    homeDir                            "user-home")
        (mkFolder    configHome                         "folder-visiting")
        (mkFolder    (builtins.dirOf dataHome)          "folder-visiting")
        (mkXdgFolder "documents")
        (mkXdgFolder "download")
        (mkFolder    "${xdgUserDirs.download}/iso"      "folder-cd")
        (mkFolder    "${xdgUserDirs.download}/torrents" "folder-torrent")
        (mkFolder    "${xdgUserDirs.extraConfig.ETC}"   "folder-notes")
        (mkFolder    "${xdgUserDirs.extraConfig.GAMES}" "folder-games")
        (mkXdgFolder "music")
        (mkFolder    "${xdgUserDirs.extraConfig.PHONE}" "")
        (mkXdgFolder "pictures")
        (mkFolder    "${xdgUserDirs.pictures}/ss"       "folder-pictures")
        (mkFolder    "${homeDir}/progs"                 "folder-applications")
        (mkXdgFolder "projects")
        (mkXdgFolder "videos")
        (mkXdgFolder "publicShare")
        (mkFolder    btrfsRootPath                      "folder-root")
        (mkFolder    persistPath                        "")
        (mkFolder    snapshotsPath                      "")
        (mkFolder    "/mnt"                             "folder-remote")
      ];
      # }}}

      description = "list of bookmarks to create.";
    };
    # }}}
  };
  # }}}

  # {{{ Config
  config = lib.mkIf cfg.enable
  {
    custom.gui.fileManagerBookmarks.gtk.enable = true;

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      gtk = lib.mkIf cfg.gtk.enable
      {
        enable = true;
        gtk3.bookmarks = map (arr: "${arr.uri} ${arr.title}") cfg.bookmarks;
      };
    };
    # }}}
  };
  # }}}
}
