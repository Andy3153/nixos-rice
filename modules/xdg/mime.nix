## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## XDG MIME config
##

{ config, lib, ... }:

let
  # {{{ Variables
  cfg       = config.custom.xdg.mime;
  defAppCfg = cfg.defaultApplications;

  mainUser = config.custom.users.mainUser;

  # {{{ App option
  appOpt = name: lib.mkOption
  {
    type        = with lib.types; either str (listOf str);
    default     = "${name}.desktop";
  };
  # }}}

  # {{{ Default apps attrset to pass to modules
  ##
  ## https://www.iana.org/assignments/media-types/media-types.xhtml
  ##

  defaultApps =
  {
    # {{{ Archive
    "application/gzip"             = defAppCfg.archive;
    "application/vnd.rar"          = defAppCfg.archive;
    "application/x-7z-compressed"  = defAppCfg.archive;
    "application/x-compressed-tar" = defAppCfg.archive;
    "application/x-tar"            = defAppCfg.archive;
    "application/zip"              = defAppCfg.archive;
    # }}}

    # {{{ Browser
    "x-scheme-handler/about"   = defAppCfg.browser;
    "x-scheme-handler/http"    = defAppCfg.browser;
    "x-scheme-handler/https"   = defAppCfg.browser;
    "x-scheme-handler/unknown" = defAppCfg.browser;
    #"application/rss+xml"      = defAppCfg.browser;
    #"application/x-xpinstall"  = defAppCfg.browser;
    #"application/xhtml+xml"    = defAppCfg.browser;
    # }}}

    # {{{ Document editor
    "application/msword"                                                        = defAppCfg.docEditor.document.ms;
    "application/rtf"                                                           = defAppCfg.docEditor.document.opendoc;
    "application/vnd.oasis.opendocument.text"                                   = defAppCfg.docEditor.document.opendoc;
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document"   = defAppCfg.docEditor.document.ms;

    "application/msexcel"                                                       = defAppCfg.docEditor.spreadsheet.ms;
    "application/vnd.oasis.opendocument.spreadsheet"                            = defAppCfg.docEditor.spreadsheet.opendoc;
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"         = defAppCfg.docEditor.spreadsheet.ms;
    "text/csv"                                                                  = defAppCfg.docEditor.spreadsheet.opendoc;

    "application/mspowerpoint"                                                  = defAppCfg.docEditor.presentation.ms;
    "application/vnd.oasis.opendocument.presentation"                           = defAppCfg.docEditor.presentation.opendoc;
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = defAppCfg.docEditor.presentation.ms;
    # }}}

    # {{{ Document viewer
    "application/pdf"               = defAppCfg.docViewer;
    "application/vnd.comicbook+zip" = defAppCfg.docViewer;
    "image/vnd.djvu"                = defAppCfg.docViewer;
    "image/vnd.djvu+multipage"      = defAppCfg.docViewer;
    # }}}

    # {{{ File manager
    "inode/directory" = defAppCfg.fileManager;
    # }}}

    # {{{ Image editor
    "image/vnd.adobe.photoshop" = defAppCfg.imgEditor.raster;
    "image/x-compressed-xcf"    = defAppCfg.imgEditor.raster;
    "image/x-xcf"               = defAppCfg.imgEditor.raster;

    "image/svg+xml"             = defAppCfg.imgEditor.vector;
    "image/svg+xml-compressed"  = defAppCfg.imgEditor.vector;

    "application/x-krita"       = defAppCfg.imgEditor.drawing;
    # }}}

    # {{{ Image viewer
    "image/avif"                     = defAppCfg.imgViewer;
    "image/bmp"                      = defAppCfg.imgViewer;
    "image/gif"                      = defAppCfg.imgViewer;
    "image/heif"                     = defAppCfg.imgViewer;
    "image/image/vnd.microsoft.icon" = defAppCfg.imgViewer;
    "image/jp2"                      = defAppCfg.imgViewer;
    "image/jpeg"                     = defAppCfg.imgViewer;
    "image/jpm"                      = defAppCfg.imgViewer;
    "image/jpx"                      = defAppCfg.imgViewer;
    "image/jxl"                      = defAppCfg.imgViewer;
    "image/png"                      = defAppCfg.imgViewer;
    "image/tiff"                     = defAppCfg.imgViewer;
    "image/webp"                     = defAppCfg.imgViewer;
    "image/x-dcraw"                  = defAppCfg.imgViewer;
    "image/x-icns"                   = defAppCfg.imgViewer;
    "image/x-xcursor"                = defAppCfg.imgViewer;
    # }}}

    # {{{ Music viewer
    "audio/aac"    = defAppCfg.musicViewer;
    "audio/flac"   = defAppCfg.musicViewer;
    "audio/mpeg"   = defAppCfg.musicViewer;
    "audio/ogg"    = defAppCfg.musicViewer;
    "audio/opus"   = defAppCfg.musicViewer;
    "audio/vorbis" = defAppCfg.musicViewer;
    "audio/wav"    = defAppCfg.musicViewer;
    # }}}

    # {{{ Text editor
    "application/json"          = defAppCfg.textEditor;
    "application/schema+json"   = defAppCfg.textEditor;
    "application/x-cdrdao-toc"  = defAppCfg.textEditor;
    "application/x-perl"        = defAppCfg.textEditor;
    "application/x-shellscript" = defAppCfg.textEditor;
    "application/x-troff-man"   = defAppCfg.textEditor;
    "application/x-zerosize"    = defAppCfg.textEditor;
    "application/xml"           = defAppCfg.textEditor;
    "text/css"                  = defAppCfg.textEditor;
    "text/html"                 = defAppCfg.textEditor;
    "text/markdown"             = defAppCfg.textEditor;
    "text/plain"                = defAppCfg.textEditor;
    "text/x-c++src"             = defAppCfg.textEditor;
    "text/x-chdr"               = defAppCfg.textEditor;
    "text/x-cmake"              = defAppCfg.textEditor;
    "text/x-csrc"               = defAppCfg.textEditor;
    "text/x-devicetree-source"  = defAppCfg.textEditor;
    "text/x-lua"                = defAppCfg.textEditor;
    "text/x-makefile"           = defAppCfg.textEditor;
    "text/x-meson"              = defAppCfg.textEditor;
    "text/x-nfo"                = defAppCfg.textEditor;
    "text/x-python3"            = defAppCfg.textEditor;
    "text/x-readme"             = defAppCfg.textEditor;
    "text/x-tex"                = defAppCfg.textEditor;
    # }}}

    # {{{ Torrent
    "application/x-bittorrent" = defAppCfg.torrent;
    "x-scheme-handler/magnet"  = defAppCfg.torrent;
    # }}}

    # {{{ Video viewer
    "application/x-matroska" = defAppCfg.vidViewer;
    "video/avi"              = defAppCfg.vidViewer;
    "video/flv"              = defAppCfg.vidViewer;
    "video/mp4"              = defAppCfg.vidViewer;
    "video/mpeg"             = defAppCfg.vidViewer;
    "video/vnd.avi"          = defAppCfg.vidViewer;
    "video/webm"             = defAppCfg.vidViewer;
    #"video/x-avi"            = defAppCfg.vidViewer;
    #"video/x-flv"            = defAppCfg.vidViewer;
    #"video/x-matroska"       = defAppCfg.vidViewer;
    #"video/x-mpeg"           = defAppCfg.vidViewer;
    # }}}

    # {{{ Windows programs
    "application/x-ms-shortcut"        = defAppCfg.winProgs;
    "application/x-msdownload"         = defAppCfg.winProgs;
    "application/x-msi"                = defAppCfg.winProgs;
    "application/x-wine-extension-msp" = defAppCfg.winProgs;
    # }}}
  };
  # }}}
  # }}}
in
{
  # {{{ Options
  options.custom.xdg.mime =
  {
    enable = lib.mkEnableOption "enables XDG MIME";

    # {{{ Default applications
    defaultApplications =
    {
      archive = appOpt "org.kde.ark";
      browser = appOpt "librewolf";

      docEditor =
      {
        document =
        {
          ms      = appOpt cfg.defaultApplications.docEditor.document.opendoc;
          opendoc = appOpt "writer";
        };

        presentation =
        {
          ms      = appOpt cfg.defaultApplications.docEditor.presentation.opendoc;
          opendoc = appOpt "impress";
        };

        spreadsheet =
        {
          ms      = appOpt cfg.defaultApplications.docEditor.spreadsheet.opendoc;
          opendoc = appOpt "calc";
        };
      };

      docViewer   = appOpt "org.pwmt.zathura";
      fileManager = appOpt "org.kde.dolphin";

      imgEditor =
      {
        drawing = appOpt "org.kde.krita";
        raster  = appOpt "gimp";
        vector  = appOpt "org.inkscape.Inkscape";
      };

      imgViewer   = appOpt "org.kde.gwenview";
      musicViewer = appOpt cfg.defaultApplications.vidViewer;
      textEditor  = appOpt "neovide";
      torrent     = appOpt "org.qbittorrent.qBittorrent";
      vidViewer   = appOpt "mpv";
      winProgs    = appOpt "com.usebottles.bottles";
    };
    # }}}
  };
  # }}}

  # {{{ Config
  config = lib.mkIf cfg.enable
  {
    xdg.mime =
    {
      enable              = true;
      addedAssociations   = defaultApps;
      defaultApplications = defaultApps;
    };

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      xdg.mime.enable = true;
      xdg.mimeApps =
      {
        enable              = true;
        associations.added  = defaultApps;
        defaultApplications = defaultApps;
      };
    };
    # }}}
  };
  # }}}
}
