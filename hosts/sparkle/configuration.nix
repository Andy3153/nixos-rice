## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `sparkle`
##
## ASUS TUF F15 FX506HM
##

{ config, lib, pkgs, pkgs-stable, ... }:

{
  imports =
  [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  hardware.nvidia.open = lib.mkForce true;

  custom =
  {
    # {{{ Boot
    boot =
    {
      #kernel            = pkgs.linuxPackages;        # LTS
      #kernel            = pkgs.linuxPackages_latest; # Stable
      kernel            = pkgs.linuxPackages_zen;    # Zen
      reisub.enable     = true;
      sysctl.swappiness = 30;
      uefiBoot.enable   = true;
    };
    # }}}

    # {{{ GUI
    gui =
    {
      enable                     = true;
      gaming.enable              = true;
      rices.hyprland-rice.enable = true;
    };
    # }}}

  # {{{ Extra packages
  extraPackages = lib.mkMerge
  [
    # {{{ NixPkgs Unstable
    (with pkgs;
    [
      # {{{ Sound
      qpwgraph                            # Sound PipeWire Patchbay
      easyeffects                         # Sound PipeWire
      pulsemixer                          # Sound sound-control
      # }}}

      # {{{ Office
      libreoffice-fresh                   # Office
      gimp                                # Office photo-editing
      inkscape                            # Office photo-editing
      krita                               # Office photo-editing

      texliveFull                         # LaTeX
      python312Packages.pygments          # for-latex
      pandoc                              # for-latex

      pdftk                               # pdf-tools
      pdfarranger                         # pdf-tools
      poppler_utils                       # pdf-tools
      # }}}

      # {{{ Media
      cantata                             # music-player for-mpd
      youtube-music                       # music-player
      flac                                # music
      opusTools                           # music
      ffmpeg                              # media-convert
      yt-dlp                              # media-download
      converseen                          # media-convert
      mousai                              # find music

      audacity                            # audio-editor
      # }}}

      # {{{ 3D
      blender                             # 3D
      # }}}

      linux-wifi-hotspot                  # Internet hotspot
      gparted                             # Partition-Manager
      okteta                              # KDE-Apps hex-editor
      mousai                              # GNOME-Apps song-identifier
      betterdiscordctl                    # for-discord
      virt-manager                        # for-libvirt
      virtiofsd                           # for-libvirt
      qbittorrent                         # torrents

      ventoy-full

      gpt4all                             # AI
    ])
    # }}}

    # {{{ NixPkgs 24.05
    (with pkgs-stable;
    [
    ])
    # }}}
  ];
  # }}}

  # {{{ Extra Flatpak packages
  extraFlatpakPackages =
  [
    "io.gitlab.librewolf-community"      # Browsers
    "com.brave.Browser"                  # Browsers
    "org.torproject.torbrowser-launcher" # Browsers Tor

    "com.discordapp.Discord"             # Social
    "dev.vencord.Vesktop"                # Social
    "io.github.trigg.discover_overlay"   # for-discord
    "org.ferdium.Ferdium"                # Social

    "com.spotify.Client"                 # Music-Players

    "sh.ppy.osu"                         # Games
  ];
  # }}}

    # {{{ Hardware
    hardware =
    {
      isLaptop              = true;
      bluetooth.powerOnBoot = false;

      gpuDrivers = lib.mkForce
      [
        "modesetting"
        "intel"
        "nvidia"
        "fbdev"
      ];

      graphictablets.enable   = true;
      openrgb.enable          = true;
      nvidia.prime.enable     = true;
    };
    # }}}

    # {{{ Programs
    programs =
    {
      # {{{ Neovim
      neovim =
      {
        enable              = true;
        enableCustomConfigs = true;
      };
      # }}}

      # {{{ Zsh
      zsh =
      {
        enable              = true;
        enableCustomConfigs = true;
      };
      # }}}

      # {{{ Git
      git =
      {
        enable    = true;
        userName  = "Andy3153";
        userEmail = "andy3153@protonmail.com";
      };
      # }}}

      adb.enable   = true;
      obs.enable   = true;
      tilp2.enable = true;
    };
    # }}}

    # {{{ Services
    services =
    {
      flatpak.enable  = true;
      mpd.enable      = true;

      printing =
      {
        enable  = true;
        drivers = [ pkgs.brlaser ];
      };

      tlp.chargeThreshold.stop = 80;
    };
    # }}}

    # {{{ Systemd
    systemd.services.TUFFanSpeed.enable = true;
    # }}}

    # {{{ Users
    users.mainUser = "andy3153";
    # }}}

    # {{{ Virtualisation
    virtualisation =
    {
      docker =
      {
        enable          = true;
        enableOnBoot    = false;
        rootless.enable = true;
      };

      #distrobox.enable = true;
      libvirtd.enable  = true;
      waydroid.enable  = false;
    };
    # }}}

    # {{{ XDG
    xdg =
    {
      # {{{ Default applications
      mime.defaultApplications =
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
      # }}}

      # {{{ User directories
      userDirs =
      let
        mainUser      = config.custom.users.mainUser;
        HM            = config.home-manager.users.${mainUser};
        homeDir       = HM.home.homeDirectory;
        xdg.cacheHome = HM.xdg.cacheHome;
        xdg.dataHome  = HM.xdg.dataHome;
      in
      {
        enable = lib.mkDefault true;
        desktop           = "${xdg.cacheHome}/xdg_desktop_folder"; # I don't need it
        documents         = "${homeDir}/docs";
        download          = "${homeDir}/downs";
        music             = "${homeDir}/music";
        pictures          = "${homeDir}/pics";
        publicShare       = "${xdg.dataHome}/xdg_public_folder";
        templates         = "${xdg.dataHome}/xdg_templates_folder";
        videos            = "${homeDir}/vids";
      };
      # }}}
    };
    # }}}
  };

  # {{{ Hosts file block list
  networking.stevenblack.enable = true;
  # }}}

  # {{{ Btrbk instances
  services.btrbk.instances =
  {
    # {{{ Daily local backup
    ##
    ## Contains subvolumes that get backed up daily, and kept locally as snapshots
    ##

    daily-local =
    {
      #onCalendar = "daily";
      onCalendar = "null";
      settings =
      {
        timestamp_format      = "long";

        snapshot_preserve     = "5d";
        snapshot_preserve_min = "2d";

        volume."/.btrfs-root" =
        {
          snapshot_dir = "snapshots";
          subvolume."root".snapshot_create = "onchange";
          subvolume."nix".snapshot_create = "onchange";
          subvolume."home".snapshot_create = "onchange";
        };
      };
    };
    # }}}

    # {{{ Backup to external hard drive
    ##
    ## Contains subvolumes that get backed up to an external hard drive
    ##

    externalhdd =
    {
      onCalendar = "null";
      settings =
      {
        timestamp_format      = "long";

        snapshot_preserve_min = "latest";

        volume."/.btrfs-root" =
        {
          snapshot_dir = "snapshots.externalhdd";

          subvolume."root".snapshot_create = "onchange";
          subvolume."root".target = "/mnt/sparkle_snapshots/";

          subvolume."nix".snapshot_create = "onchange";
          subvolume."nix".target = "/mnt/sparkle_snapshots/";

          subvolume."home".snapshot_create = "onchange";
          subvolume."home".target = "/mnt/sparkle_snapshots/";
        };
      };
    };
    # }}}

    # {{{ Backup to external hard drive (full)
    ##
    ## Contains subvolumes that get backed up to an external hard drive
    ##

    externalhdd-full =
    {
      onCalendar = "null";
      settings =
      {
        timestamp_format      = "long";

        snapshot_preserve_min = "latest";

        volume."/.btrfs-root" =
        {
          snapshot_dir = "snapshots.externalhdd";

          subvolume."root".snapshot_create = "onchange";
          subvolume."root".target = "/mnt/sparkle_snapshots/";

          subvolume."nix".snapshot_create = "onchange";
          subvolume."nix".target = "/mnt/sparkle_snapshots/";

          subvolume."home".snapshot_create = "onchange";
          subvolume."home".target = "/mnt/sparkle_snapshots/";

          subvolume."games".snapshot_create = "onchange";
          subvolume."games".target = "/mnt/sparkle_snapshots/";

          subvolume."vms".snapshot_create = "onchange";
          subvolume."vms".target = "/mnt/sparkle_snapshots/";

          subvolume."torrents".snapshot_create = "onchange";
          subvolume."torrents".target = "/mnt/sparkle_snapshots/";

          subvolume.".beeshome".snapshot_create = "onchange";
          subvolume.".beeshome".target = "/mnt/sparkle_snapshots/";
        };
      };
    };
    # }}}
  };
  # }}}
}
