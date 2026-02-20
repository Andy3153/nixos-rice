## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Config for hostname `sparkle`
##
## ASUS TUF F15 FX506HM
##

{ config, lib, pkgs, pkgs-unstable, pkgs-stable, my-pkgs, ... }:

{
  # {{{ BeamMP certificate problem
  security.pki.certificateFiles =
  [(pkgs.stdenvNoCC.mkDerivation
  {
    name = "beammp-cert";
    nativeBuildInputs = [ pkgs.curl ];
    builder = (pkgs.writeScript "beammp-cert-builder" "curl -w %{certs} https://auth.beammp.com/userlogin -k > $out");
    outputHash = "sha256-bHQWQbPBplhu7hq8CcRwJAfBaNGRQ70kihd/BCu4QnA=";
  })];
  # }}}

  custom =
  {
    # {{{ Boot
    boot =
    {
      #kernel               = pkgs.linuxPackages;        # LTS
      #kernel               = pkgs.linuxPackages_latest; # Stable
      kernel               = pkgs.linuxPackages_zen;    # Zen

      sysctl =
      {
        kernel.sysrq  = 244; # enable REISUB
        vm.swappiness = 10;
      };

      uefi =
      {
        enable = true;
        secure-boot.enable = true;
      };
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
  extraPackages = lib.lists.flatten
  [
    # {{{ Default NixPkgs
    (with pkgs;
    [
      # {{{ Sound
      qpwgraph    # Sound PipeWire Patchbay
      easyeffects # Sound PipeWire
      pulsemixer  # Sound sound-control
      # }}}

      # {{{ Office
      libreoffice-qt6           # Office
      onlyoffice-desktopeditors # Office
      gimp3-with-plugins        # Office photo-editing
      inkscape                  # Office photo-editing
      krita                     # Office photo-editing

      texliveFull                # LaTeX
      texpresso                  # for-latex
      python312Packages.pygments # for-latex
      pandoc                     # for-latex
      ghostscript                # for-latex pdf-tools

      pdftk         # pdf-tools
      pdfarranger   # pdf-tools
      poppler-utils # pdf-tools

      pomodoro-gtk # timer pomodoro-timer
      timewarrior  # timer time-tracker
      # }}}

      # {{{ Media
      cantata      # music-player for-mpd
      pear-desktop # music-player youtube-music

      grayjay # youtube

      flac       # music
      opus-tools # music
      mousai     # music find-music
      picard     # music tag-music
      lrcget     # music get-lyrics
      shntool    # music split-cue

      ffmpeg     # media-convert
      yt-dlp     # media-download
      converseen # media-convert

      audacity # audio-editor

      exiftool # image-data
      # }}}

      # {{{ 3D
      blender # 3D
      # }}}

      # {{{ Partitioning/Filesystems
      gparted # Partition-Manager
      fatsort # Filesystems sort-fat-fs

      adbfs-rootless # Filesystems FUSE ADB

      (testdisk.override
      {
        enableQt = true;
        enableNtfs = true;
        enableExtFs = true;
      })

      f3 # flash-drive-tester
      # }}}

      # {{{ Programming
      gh # github for-git
      # }}}

      linux-wifi-hotspot # Internet hotspot
      okteta             # KDE-Apps hex-editor
      mousai             # GNOME-Apps song-identifier
      qbittorrent        # torrents
      scrcpy             # adb-tools
      adb-sync           # adb-tools
      wimlib             # .wim
      ventoy-full        # flash-usbs
      woeusb             # flash-usbs windows
      d-spy              # D-Bus
      ciscoPacketTracer9 # Networking
      openbox            # for-xwayland-rootless-script
      jq                 # Other-CLI json
      hjson              # Other-CLI json
    ])
    # }}}

    # {{{ NixPkgs Unstable
    (with pkgs-unstable;
    [
    ])
    # }}}

    # {{{ NixPkgs Stable
    (with pkgs-stable;
    [
    ])
    # }}}

    # {{{ My Nix packages
    (with my-pkgs;
    [
      # {{{ Media
      syrics                              # music get-lyrics
      # }}}
    ])
    # }}}
  ];
  # }}}

  # {{{ Extra Flatpak packages
  extraFlatpakPackages =
  [
    "com.brave.Browser"                  # Browsers
    "org.torproject.torbrowser-launcher" # Browsers Tor

    "dev.vencord.Vesktop"                # Social
    "org.ferdium.Ferdium"                # Social

    "com.wps.Office"                     # Office

    "com.spotify.Client"                 # Music-Players

    "sh.ppy.osu"                         # Games
  ];
  # }}}

    # {{{ Hardware
    hardware =
    {
      bluetooth =
      {
        enable = true;
        powerOnBoot = false;
      };

      gpuDrivers = lib.mkForce
      [
        "modesetting"
        "intel"
        "nvidia"
        "fbdev"
      ];

      nvidia =
      {
        enable       = true;
        prime.enable = true;
      };

      graphictablets.enable = true;
      openrgb.enable        = true;
      piper.enable          = true;
      thunderbolt.enable    = true;
    };
    # }}}

    # {{{ Networking
    networking.stevenblack.enable = true;
    # }}}

    # {{{ Nix
    nix =
    {
      unfreeWhitelist =
      [
        "android-sdk-platform-tools"
        "cisco-packet-tracer"
        "grayjay"
        "platform-tools"
        "ventoy"
      ];

      insecureWhitelist =
      [
        "ventoy-1.1.10"
      ];
    };
    # }}}

    # {{{ Programs
    programs =
    {
      # {{{ Git
      git =
      {
        enable     = true;
        lfs.enable = true;
        userName   = "Andy3153";
        userEmail  = "andy3153@protonmail.com";
      };
      # }}}

      # {{{ Neovim
      neovim =
      {
        enable              = true;
        enableCustomConfigs = true;
      };
      # }}}

      # {{{ SSH
      ssh =
      {
        enable = true;

        # {{{ Settings to use with different hosts
        matchBlocks =
        # {{{ Variables
        let
          mainUser = config.custom.users.mainUser;
          HM       = config.home-manager.users.${mainUser};
          homeDir  = HM.home.homeDirectory;
        in
        # }}}
        {
          # {{{ AUR
          "aur.archlinux.org" =
          {
            hostname       = "aur.archlinux.org";
            user           = "git";
            identityFile   = "${homeDir}/.ssh/id_ed25519-aur"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-aur -C "sparkle-aur"
            identitiesOnly = true;
          };
          # }}}

          # {{{ `helix`
          "helix" =
          {
            hostname       = "helix";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            identitiesOnly = true;
          };

          "andy3153.am-furnici.ro" =
          {
            hostname       = "andy3153.am-furnici.ro";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            identitiesOnly = true;
          };

          "andy3153.go.ro" =
          {
            hostname       = "andy3153.go.ro";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            identitiesOnly = true;
          };

          "andy3153.duckdns.org" =
          {
            hostname       = "andy3153.duckdns.org";
            user           = mainUser;
            identityFile   = "${homeDir}/.ssh/id_ed25519-helix"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-helix -C "sparkle-helix"
            identitiesOnly = true;
          };
          # }}}

          # {{{ GitHub
          "github.com" =
          {
            hostname       = "github.com";
            user           = "git";
            identityFile   = "${homeDir}/.ssh/id_ed25519-github"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-github -C "sparkle-github"
            identitiesOnly = true;
          };
          # }}}

          # {{{ GitLab
          "gitlab.com" =
          {
            hostname       = "gitlab.com";
            user           = "git";
            identityFile   = "${homeDir}/.ssh/id_ed25519-gitlab"; # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519-gitlab -C "sparkle-gitlab"
            identitiesOnly = true;
          };
          # }}}
        };
        # }}}
      };
      # }}}

      # {{{ Zsh
      zsh =
      {
        enable              = true;
        enableCustomConfigs = true;
      };
      # }}}

      adb.enable       = true;
      appimage.enable  = true;
      direnv.enable    = true;
      librewolf.enable = true;
      obs.enable       = true;
      tilp2.enable     = true;
    };
    # }}}

    # {{{ Services
    services =
    {
      flatpak.enable = true;
      mpd.enable     = true;

      openssh =
      {
        enable   = true;
        settings = { X11Forwarding = true; };
      };

      printing =
      {
        enable  = true;
        drivers = [ pkgs.brlaser ];
      };

      tlp =
      {
        enable = true;
        chargeThreshold.stop = 80;
      };

      upower.enable = true;
    };
    # }}}

    # {{{ Systemd
    systemd.services.tufFanSpeed.enable = true;
    # }}}

    # {{{ Users
    users.mainUser = "andy3153";
    # }}}

    # {{{ Virtualisation
    virtualisation =
    {
      binfmt.emulatedSystems = [ "aarch64-linux" ];

      docker =
      {
        enable          = true;
        enableOnBoot    = false;
        #rootless.enable = true;
      };

      podman.enable    = true;

      distrobox.enable = true;
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

        archive                        = "org.kde.ark.desktop";
        browser                        = "librewolf.desktop";
        docEditor.document.ms          = docEditor.document.opendoc;
        docEditor.document.opendoc     = "writer.desktop";
        docEditor.presentation.ms      = docEditor.presentation.opendoc;
        docEditor.presentation.opendoc = "impress.desktop";
        docEditor.spreadsheet.ms       = docEditor.spreadsheet.opendoc;
        docEditor.spreadsheet.opendoc  = "calc.desktop";
        docViewer                      = "org.pwmt.zathura.desktop";
        fileManager                    = "org.kde.dolphin.desktop";
        imgEditor.drawing              = "krita-2.desktop";
        imgEditor.raster               = "gimp.desktop";
        imgEditor.vector               = "org.inkscape.Inkscape.desktop";
        imgViewer                      = "org.kde.gwenview.desktop";
        musicViewer                    = vidViewer;
        textEditor                     = "neovide.desktop";
        torrent                        = "org.qbittorrent.qBittorrent.desktop";
        vidViewer                      = "mpv.desktop";
        winProgs                       = "com.usebottles.bottles.desktop";
        # }}}
      in
      {
        # {{{ Assigning of MIMEtypes from default applications
        ##
        ## https://www.iana.org/assignments/media-types/media-types.xhtml
        ##

        # {{{ Archive
        "application/gzip"             = archive;
        "application/vnd.rar"          = archive;
        "application/x-7z-compressed"  = archive;
        "application/x-compressed-tar" = archive;
        "application/x-tar"            = archive;
        "application/zip"              = archive;
        # }}}

        # {{{ Browser
        "x-scheme-handler/about"   = browser;
        "x-scheme-handler/http"    = browser;
        "x-scheme-handler/https"   = browser;
        "x-scheme-handler/unknown" = browser;
        #"application/rss+xml"      = browser;
        #"application/x-xpinstall"  = browser;
        #"application/xhtml+xml"    = browser;
        # }}}

        # {{{ Document editor
        "application/msword"                                                        = docEditor.document.ms;
        "application/rtf"                                                           = docEditor.document.opendoc;
        "application/vnd.oasis.opendocument.text"                                   = docEditor.document.opendoc;
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"   = docEditor.document.ms;

        "application/msexcel"                                                       = docEditor.spreadsheet.ms;
        "application/vnd.oasis.opendocument.spreadsheet"                            = docEditor.spreadsheet.opendoc;
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"         = docEditor.spreadsheet.ms;
        "text/csv"                                                                  = docEditor.spreadsheet.opendoc;

        "application/mspowerpoint"                                                  = docEditor.presentation.ms;
        "application/vnd.oasis.opendocument.presentation"                           = docEditor.presentation.opendoc;
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = docEditor.presentation.ms;
        # }}}

        # {{{ Document viewer
        "application/pdf"               = docViewer;
        "application/vnd.comicbook+zip" = docViewer;
        "image/vnd.djvu"                = docViewer;
        "image/vnd.djvu+multipage"      = docViewer;
        # }}}

        # {{{ File manager
        "inode/directory" = fileManager;
        # }}}

        # {{{ Image editor
        "image/vnd.adobe.photoshop" = imgEditor.raster;
        "image/x-compressed-xcf"    = imgEditor.raster;
        "image/x-xcf"               = imgEditor.raster;

        "image/svg+xml"             = imgEditor.vector;
        "image/svg+xml-compressed"  = imgEditor.vector;

        "application/x-krita"       = imgEditor.drawing;
        # }}}

        # {{{ Image viewer
        "image/avif"                     = imgViewer;
        "image/bmp"                      = imgViewer;
        "image/gif"                      = imgViewer;
        "image/heif"                     = imgViewer;
        "image/image/vnd.microsoft.icon" = imgViewer;
        "image/jp2"                      = imgViewer;
        "image/jpeg"                     = imgViewer;
        "image/jpm"                      = imgViewer;
        "image/jpx"                      = imgViewer;
        "image/jxl"                      = imgViewer;
        "image/png"                      = imgViewer;
        "image/tiff"                     = imgViewer;
        "image/webp"                     = imgViewer;
        "image/x-dcraw"                  = imgViewer;
        "image/x-icns"                   = imgViewer;
        "image/x-xcursor"                = imgViewer;
        # }}}

        # {{{ Music viewer
        "audio/aac"    = musicViewer;
        "audio/flac"   = musicViewer;
        "audio/mpeg"   = musicViewer;
        "audio/ogg"    = musicViewer;
        "audio/opus"   = musicViewer;
        "audio/vorbis" = musicViewer;
        "audio/wav"    = musicViewer;
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

        # {{{ Torrent
        "application/x-bittorrent" = torrent;
        "x-scheme-handler/magnet"  = torrent;
        # }}}

        # {{{ Video viewer
        "application/x-matroska" = vidViewer;
        "video/avi"              = vidViewer;
        "video/flv"              = vidViewer;
        "video/mp4"              = vidViewer;
        "video/mpeg"             = vidViewer;
        "video/vnd.avi"          = vidViewer;
        "video/webm"             = vidViewer;
        #"video/x-avi"            = vidViewer;
        #"video/x-flv"            = vidViewer;
        #"video/x-matroska"       = vidViewer;
        #"video/x-mpeg"           = vidViewer;
        # }}}

        # {{{ Windows programs
        "application/x-ms-shortcut"        = winProgs;
        "application/x-msdownload"         = winProgs;
        "application/x-msi"                = winProgs;
        "application/x-wine-extension-msp" = winProgs;
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

  # {{{ Btrbk instances
  services.btrbk.instances =
  {
    # {{{ Daily local snapshot
    ##
    ## Contains subvolumes that get backed up daily, and kept locally as snapshots
    ##

    daily-local =
    {
      onCalendar = "daily";
      settings =
      {
        timestamp_format = "long";

        snapshot_preserve     = "5d";
        snapshot_preserve_min = "2d";

        volume."/.btrfs-root" =
        {
          snapshot_dir = "snapshots";

          subvolume."root".snapshot_create = "onchange";
          subvolume."home".snapshot_create = "onchange";
        };
      };
    };
    # }}}
  };
  # }}}

  # {{{ Specialisations
  specialisation =
  {
    # {{{ No firewall
    noFirewall.configuration =
    {
      system.nixos.tags                     = [ "no-firewall" ];
      environment.etc."specialisation".text = "noFirewall"; # for nh

      networking.firewall.enable         = lib.mkForce false;
      custom.services.zerotierone.enable = true;
    };
    # }}}

    # {{{ GPU passthrough to VM
    gpuPassthrough.configuration =
    {
      system.nixos.tags                     = [ "gpu-passthrough" ];
      environment.etc."specialisation".text = "gpuPassthrough"; # for nh

      custom =
      {
        hardware =
        {
          gpuPassthrough =
          {
            enable = true;
            cpu    = "intel";
            gpu    = "nvidia";
            gpuIDs = [ "10de:2520" "10de:228e" ]; # 3060 mobile
          };

          nvidia =
          {
            enable       = lib.mkForce false;
            prime.enable = lib.mkForce false;
          };
        };
      };
    };
    # }}}
  };
  # }}}

  system.stateVersion = "25.11";
}
