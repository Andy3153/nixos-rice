## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## GUI bundle
##

{ config, lib, ... }:

let
  cfg = config.custom.gui;
in
{
  imports =
  [
    ./dm
    ./rices
    ./theme
    ./wm
    ./apps.nix
    ./gaming.nix
  ];

  options.custom.gui.enable = lib.mkEnableOption "enables a GUI";

  config = lib.mkIf cfg.enable
  {
    custom =
    {
      boot.plymouth.enable = lib.mkDefault true;

      gui =
      {
        apps.enable                 = lib.mkDefault true;

        gaming.enable               = lib.mkDefault false;
        gaming.optimizations.enable = lib.mkDefault config.custom.gui.gaming.enable;
      };

      hardware.opengl.enable  = lib.mkDefault true;
      programs.dconf.enable   = lib.mkDefault true;
      services.udisks2.enable = lib.mkDefault true;

      xdg =
      {
        enable        = lib.mkDefault true;
        portal.enable = lib.mkDefault true;
        mime =
        {
          enable = lib.mkDefault true;
          defaultApplications =
          let
            # {{{ Default applications
            ##
            ## All .desktop files live inside folders from $XDG_DATA_DIRS
            ##

            browser                        = "io.gitlab.librewolf-community.desktop";
            fileManager                    = "org.kde.dolphin.desktop";
            textEditor                     = "neovide.desktop";
            docViewer                      = "org.pwmt.zathura.desktop";
            docEditor.document.opendoc     = "writer.desktop";
            docEditor.document.ms          = docEditor.document.opendoc;
            docEditor.spreadsheet.opendoc  = "calc.desktop";
            docEditor.spreadsheet.ms       = docEditor.spreadsheet.opendoc;
            docEditor.presentation.opendoc = "impress.desktop";
            docEditor.presentation.ms      = docEditor.presentation.opendoc;
            imgViewer                      = "org.kde.gwenview.desktop";
            imgEditor.raster               = "gimp.desktop";
            imgEditor.vector               = "org.inkscape.Inkscape.desktop";
            imgEditor.drawing              = "krita-2.desktop";
            vidViewer                      = "mpv.desktop";
            archive                        = "org.kde.ark.desktop";
            winProgs                       = "com.usebottles.bottles.desktop";
            torrent                        = "org.qbittorrent.qBittorrent.desktop";
            # }}}
          in
          {
            # {{{ Assigning of MIMEtypes from default applications
            # {{{ Browser
            #"application/rss+xml"      = browser;
            #"application/x-xpinstall"  = browser;
            #"application/xhtml+xml"    = browser;
            "x-scheme-handler/http"    = browser;
            "x-scheme-handler/https"   = browser;
            "x-scheme-handler/about"   = browser;
            "x-scheme-handler/unknown" = browser;
            # }}}

            # {{{ File manager
            "inode/directory" = fileManager;
            # }}}

            # {{{ Text editor
            "application/json"          = textEditor;
            "application/schema+json"   = textEditor;
            "application/x-cdrdao-toc"  = textEditor;
            "application/x-perl"        = textEditor;
            "application/x-shellscript" = textEditor;
            "application/x-troff-man"   = textEditor;
            "application/x-zerosize"    = textEditor;
            "application/xml"           = textEditor;
            "text/css"                  = textEditor;
            "text/html"                 = textEditor;
            "text/markdown"             = textEditor;
            "text/plain"                = textEditor;
            "text/x-c++src"             = textEditor;
            "text/x-chdr"               = textEditor;
            "text/x-cmake"              = textEditor;
            "text/x-csrc"               = textEditor;
            "text/x-devicetree-source"  = textEditor;
            "text/x-lua"                = textEditor;
            "text/x-makefile"           = textEditor;
            "text/x-meson"              = textEditor;
            "text/x-nfo"                = textEditor;
            "text/x-python3"            = textEditor;
            "text/x-readme"             = textEditor;
            "text/x-tex"                = textEditor;
            # }}}

            # {{{ Document viewer
            "application/pdf"               = docViewer;
            "application/vnd.comicbook+zip" = docViewer;
            "image/vnd.djvu"                = docViewer;
            "image/vnd.djvu+multipage"      = docViewer;
            # }}}

            # {{{ Document editor
            "application/msword"                                                        = docEditor.document.ms;
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document"   = docEditor.document.ms;
            "application/vnd.oasis.opendocument.text"                                   = docEditor.document.opendoc;
            "application/rtf"                                                           = docEditor.document.opendoc;

            "application/msexcel"                                                       = docEditor.spreadsheet.ms;
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"         = docEditor.spreadsheet.ms;
            "application/vnd.oasis.opendocument.spreadsheet"                            = docEditor.spreadsheet.opendoc;
            "text/csv"                                                                  = docEditor.spreadsheet.opendoc;

            "application/mspowerpoint"                                                  = docEditor.presentation.ms;
            "application/vnd.openxmlformats-officedocument.presentationml.presentation" = docEditor.presentation.ms;
            "application/vnd.oasis.opendocument.presentation"                           = docEditor.presentation.opendoc;
            # }}}

            # {{{ Image viewer
            "image/avif"                     = imgViewer;
            "image/bmp"                      = imgViewer;
            "image/gif"                      = imgViewer;
            "image/heif"                     = imgViewer;
            "image/jpeg"                     = imgViewer;
            "image/jp2"                      = imgViewer;
            "image/jpm"                      = imgViewer;
            "image/jpx"                      = imgViewer;
            "image/jxl"                      = imgViewer;
            "image/png"                      = imgViewer;
            "image/tiff"                     = imgViewer;
            "image/webp"                     = imgViewer;
            "image/image/vnd.microsoft.icon" = imgViewer;
            "image/x-dcraw"                  = imgViewer;
            "image/x-icns"                   = imgViewer;
            "image/x-xcursor"                = imgViewer;
            # }}}

            # {{{ Image editor
            "image/vnd.adobe.photoshop" = imgEditor.raster;
            "image/x-xcf"               = imgEditor.raster;
            "image/x-compressed-xcf"    = imgEditor.raster;

            "image/svg+xml"             = imgEditor.vector;
            "image/svg+xml-compressed"  = imgEditor.vector;

            "application/x-krita"       = imgEditor.drawing;
            # }}}

            # {{{ Video viewer
            "application/x-matroska" = vidViewer;
            "video/avi"              = vidViewer;
            "video/flv"              = vidViewer;
            "video/mp4"              = vidViewer;
            "video/mpeg"             = vidViewer;
            "video/webm"             = vidViewer;
            "video/vnd.avi"          = vidViewer;
            #"video/x-avi"            = vidViewer;
            #"video/x-matroska"       = vidViewer;
            #"video/x-mpeg"           = vidViewer;
            #"video/x-flv"            = vidViewer;
            # }}}

            # {{{ Archive
            "application/gzip"             = archive;
            "application/vnd.rar"          = archive;
            "application/x-7z-compressed"  = archive;
            "application/x-compressed-tar" = archive;
            "application/x-tar"            = archive;
            "application/zip"              = archive;
            # }}}

            # {{{ Windows programs
            "application/x-ms-shortcut"        = winProgs;
            "application/x-wine-extension-msp" = winProgs;
            "application/x-msdownload"         = winProgs;
            "application/x-msi"                = winProgs;
            # }}}

            # {{{ Torrent
            "application/x-bittorrent" = torrent;
            "x-scheme-handler/magnet"  = torrent;
            # }}}
            # }}}
          };
        };
      };
    };
  };
}
