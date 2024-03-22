## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Home Manager configuration by Andy3153
## created   03/09/23 ~ 16:57:11
## rewrote   15/03/24 ~ 17:06:25
##

{ config, pkgs, ... }:

{
  news.display = "notify";

  # {{{ Dconf
  dconf.settings =
  {
    # {{{ Autoconnect virt-manager to system QEMU
    "org/virt-manager/virt-manager/connections" =
    {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
    # }}}
  };
  # }}}

  # {{{ Fonts
  fonts.fontconfig.enable = true;
  # }}}

  # {{{ GTK
  gtk =
  {
    enable              = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # {{{ Cursor
    cursorTheme =
    {
      package = config.home.pointerCursor.package;
      name    = config.home.pointerCursor.name;
      size    = config.home.pointerCursor.size;
    };
    # }}}

    # {{{ Font
    font =
    {
      package = pkgs.cantarell-fonts;
      name    = "Cantarell";
      #size    = ;
    };
    # }}}

    # {{{ Icon theme
    iconTheme =
    {
      package = pkgs.catppuccin-papirus-folders.override
      {
        flavor = "mocha";
      };

      name    = "Papirus-Dark";
    };
    # }}}

    # {{{ Theme
    theme =
    {
      package = pkgs.catppuccin-gtk.override
      {
        variant = "mocha";
      };

      name    = "Catppuccin-Mocha-Standard-Blue-Dark";
    };
    # }}}
  };
  # }}}

  # {{{ Home
  home =
  {
    # {{{ Basic info
    stateVersion = "23.11";

    username      = "andy3153";
    homeDirectory = "/home/andy3153/";
    # }}}

    # {{{ Packages
    packages = with pkgs;
    [
      # {{{ Hyprland Rice
      libcanberra-gtk3             # hyprland-rice play-system-sounds
      hyprpaper                    # hyprland-rice wallpaper
      hypridle                     # hyprland-rice idle-manager
      hyprlock                     # hyprland-rice lock-screen
      hyprpicker                   # hyprland-rice color-picker
      swayosd                      # hyprland-rice osd
      polkit-kde-agent             # hyprland-rice polkit-agent
      xwaylandvideobridge          # hyprland-rice xwayland-screenshare
      wev                          # hyprland-rice event-viewer
      rofi-wayland                 # hyprland-rice appmenu
      kitty                        # hyprland-rice terminal
      waybar                       # hyprland-rice status-bar
      blueman                      # hyprland-rice bluetooth-control
      networkmanager_dmenu         # hyprland-rice network-control
      lxqt.pavucontrol-qt          # hyprland-rice Sound sound-control
      nwg-bar                      # hyprland-rice logout-menu
      flameshot                    # hyprland-rice screenshot
      grim                         # hyprland-rice screenshot for-flameshot
      slurp                        # hyprland-rice screenshot for-flameshot

      mpv                          # hyprland-rice video-player
      mpvScripts.mpris             # hyprland-rice for-mpv

      zathura                      # hyprland-rice pdf-viewer

      kcalc                        # hyprland-rice KDE-Apps calculator
      kdePackages.kdeconnect-kde   # hyprland-rice KDE-Apps
      dolphin                      # hyprland-rice KDE-Apps file-manager
      ark                          # hyprland-rice KDE-Apps archive-manager
      gwenview                     # hyprland-rice KDE-Apps image-viewer
      okular                       # hyprland-rice KDE-Apps pdf-viewer
      kcharselect                  # hyprland-rice KDE-Apps character-select
      filelight                    # hyprland-rice KDE-Apps disk-usage-analyzer
      kdePackages.kruler           # hyprland-rice KDE-Apps on-screen-ruler
      merkuro                      # hyprland-rice KDE-Apps calendar contacts
      # }}}

      # {{{ Sound
      qpwgraph                     # Sound PipeWire Patchbay
      easyeffects                  # Sound PipeWire
      pulsemixer                   # Sound sound-control
      # }}}

      # {{{ Office
      libreoffice-fresh            # Office
      gimp                         # Office photo-editing
      inkscape                     # Office photo-editing

      texliveFull                  # LaTeX
      python312Packages.pygments   # for-latex
      pandoc                       # for-latex

      pdftk                        # pdf-tools
      pdfarranger                  # pdf-tools
      # }}}

      # {{{ Media
      cantata                      # music-player for-mpd
      youtube-music                # music-player
      flac                         # music
      opusTools                    # music
      ffmpeg                       # music video
      audacity                     # music
      # }}}

      # {{{ Games
      depotdownloader              # for-steam
      extest                       # for-steam for-controllers
      wineWowPackages.staging      # wine
      protonup-qt                  # for-steam for-wine
      protontricks                 # for-steam for-wine

      bottles                      # for-wine
      lutris                       # for-wine
      # }}}

      yt-dlp                       # download
      linux-wifi-hotspot           # Internet hotspot
      gparted                      # Partition-Manager
      okteta                       # KDE-Apps hex-editor
      mousai                       # GNOME-Apps song-identifier
      betterdiscordctl             # for-discord
      virt-manager                 # for-libvirt
      qbittorrent                  # torrents
    ];
    # }}}

    # {{{ File
    # {{{ Get the files
    ## Variables
    #ghlink="https://github.com/Andy3153"
    #
    ## Create folder structure
    #mkdir -p /home/andy3153/src
    #cd /home/andy3153/src
    #mkdir -p hyprland/hyprland-rice
    #mkdir -p nixos/nixos-rice
    #mkdir -p nvim/andy3153-init.lua
    #mkdir -p sh/andy3153-zshrc
    #
    ## Clone Git repos
    #git clone $ghlink/hyprland-rice hyprland/hyprland-rice
    #git clone $ghlink/nixos-rice nixos/nixos-rice
    #git clone $ghlink/andy3153-init.lua nvim/andy3153-init.lua
    #git clone $ghlink/andy3153-zshrc sh/andy3153-zshrc
    #
    ## Finish
    #cd
    # }}}

    file =
    {
      ".config/zsh".source     = ~/src/sh/andy3153-zshrc;

      ".config/nvim".source    = ~/src/nvim/andy3153-init.lua;
      ".config/nvim".recursive = true; # because packer creates some files in the nvim folder

      # {{{ Hyprland Rice
      ".config/btop".source                    = ~/src/hyprland/hyprland-rice/dotconfig/btop;
      #".config/cava".source                    = ~/src/hyprland/hyprland-rice/dotconfig/cava;
      ".config/css-common".source              = ~/src/hyprland/hyprland-rice/dotconfig/css-common;
      ".config/dunst".source                   = ~/src/hyprland/hyprland-rice/dotconfig/dunst;
      ".config/fastfetch".source               = ~/src/hyprland/hyprland-rice/dotconfig/fastfetch;
      ".config/flameshot".source               = ~/src/hyprland/hyprland-rice/dotconfig/flameshot;
      ##".config/fontconfig".source              = ~/src/hyprland/hyprland-rice/dotconfig/fontconfig;
      #".config/fuzzel".source                  = ~/src/hyprland/hyprland-rice/dotconfig/fuzzel;
      ##".config/gtk-2.0".source                 = ~/src/hyprland/hyprland-rice/dotconfig/gtk-2.0;
      ##".config/gtk-3.0".source                 = ~/src/hyprland/hyprland-rice/dotconfig/gtk-3.0;
      ".config/htop".source                    = ~/src/hyprland/hyprland-rice/dotconfig/htop;
      ".config/hypr".source                    = ~/src/hyprland/hyprland-rice/dotconfig/hypr;
      ".config/kitty".source                   = ~/src/hyprland/hyprland-rice/dotconfig/kitty;
      #".config/lf".source                      = ~/src/hyprland/hyprland-rice/dotconfig/lf;
      ".config/mpv".source                     = ~/src/hyprland/hyprland-rice/dotconfig/mpv;
      ".config/networkmanager-dmenu".source    = ~/src/hyprland/hyprland-rice/dotconfig/networkmanager-dmenu;
      ".config/nwg-bar".source                 = ~/src/hyprland/hyprland-rice/dotconfig/nwg-bar;
      #".config/nwg-dock-hyprland".source       = ~/src/hyprland/hyprland-rice/dotconfig/nwg-dock-hyprland;
      #".config/nwg-drawer".source              = ~/src/hyprland/hyprland-rice/dotconfig/nwg-drawer;
      ".config/qt5ct".source                   = ~/src/hyprland/hyprland-rice/dotconfig/qt5ct;
      ".config/qt6ct".source                   = ~/src/hyprland/hyprland-rice/dotconfig/qt5ct;
      ".config/rofi".source                    = ~/src/hyprland/hyprland-rice/dotconfig/rofi;
      #".config/swayidle".source                = ~/src/hyprland/hyprland-rice/dotconfig/swayidle;
      #".config/swaylock".source                = ~/src/hyprland/hyprland-rice/dotconfig/swaylock;
      #".config/swaync".source                  = ~/src/hyprland/hyprland-rice/dotconfig/swaync;
      ".config/waybar".source                  = ~/src/hyprland/hyprland-rice/dotconfig/waybar;
      #".config/xava".source                    = ~/src/hyprland/hyprland-rice/dotconfig/xava;
      ".config/zathura".source                 = ~/src/hyprland/hyprland-rice/dotconfig/zathura;

      ".local/share/sounds".source             = ~/src/hyprland/hyprland-rice/dotlocal/share/sounds;
      ".local/share/wallpapers".source         = ~/src/hyprland/hyprland-rice/dotlocal/share/wallpapers;
      ".local/share/wallpaper.png".source      = ~/.local/share/wallpapers/wallpaper4.png;
      ".local/share/wallpaper-lock.png".source = ~/.local/share/wallpapers/wallpaper4.png;
      # }}}
    };
    # }}}

    # {{{ Cursor
    pointerCursor =
    {
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name    = "macOS-Monterey";
      size    = 24;
    };
    # }}}

    # {{{ Environment variables
    sessionVariables =
    {
      # Home Manager can also manage your environment variables through
      # 'home.sessionVariables'. If you don't want to manage your shell through Home
      # Manager then you have to manually source 'hm-session-vars.sh' located at
      # either
      #
      #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  /etc/profiles/per-user/andy3153/etc/profile.d/hm-session-vars.sh
      #
    };
    # }}}
  };
  # }}}

  # {{{ Programs
  programs =
  {
    home-manager.enable = true; # let HM manage itself

    # {{{ Hyprland Rice
    #kitty.enable  = true;  # hyprland-rice terminal
    #waybar.enable = true;  # hyprland-rice status-bar
    # }}}

    # {{{ Git
    git =
    {
      enable    = true;
      userEmail = "andy3153@protonmail.com";
      userName  = "Andy3153";

      # {{{ Extra configuration
      extraConfig =
      {
        core =
        {
          autocrlf = "input";
          safecrlf = "true";
        };

        merge.tool              = "vimdiff";
        mergetool.prompt        = true;
        mergetool."vimdiff".cmd = "nvim -d $REMOTE $LOCAL";

        diff.tool               = "vimdiff";
        difftool.prompt         = false;
      };
      # }}}

      # {{{ Files to ignore
      ignores =
      [
        "**/*.bak"
        "**/*.old"
        "**/.directory"
        "**/*.kate-swp"
        "**/*.kdev4"
        "**/.idea"
        "**/*.aux"
        "**/*.log"
        "**/*.out"
        "**/*.synctex.gz"
        "**/*.toc"
        "**/*.pyg"
        "**/*.latexrun.db"
        "**/*.latexrun.db.lock"
        "**/*.fdb_latexmk"
        "**/*.fls"
        "**/*.xdv"
      ];
      # }}}
    };
    # }}}

    # {{{ MangoHud
    mangohud =
    {
      enable   = true;
      settings =
      {
        position         = "top-left"; # on-screen position
        round_corners    = 0;          # rounded corners
        frame_timing     = false;      # frame timing

        # {{{ Horizontal layout
        horizontal          = true;
        hud_compact         = true;
        hud_no_margin       = true;
        # }}}

        # {{{ Background
        background_alpha    = "0";
        background_color    = "020202";
        # }}}

        # {{{ Font
        font_size           = 20;
        font_size_text      = 24;
        font_scale          = 0.7;
        text_color          = "ffffff";
        # }}}

        # {{{ Keybinds
        toggle_hud          = "Control_L+Alt_L+M";
        toggle_logging      = "Shift_L+F2";
        upload_log          = "Shift_L+F5";
        # }}}

        # {{{ FPS Counter
        fps                 = true;
        engine_color        = "eb5b5b";
        wine_color          = "eb5b5b";
        # }}}

        # {{{ CPU Stats
        cpu_stats           = true;
        cpu_temp            = true;
        cpu_color           = "2e97cb";
        cpu_text            = "CPU";
        # }}}

        # {{{ GPU Stats
        gpu_stats           = true;
        gpu_temp            = true;
        gpu_color           = "2e9762";
        gpu_text            = "GPU";
        # }}}

        # {{{ RAM/Swap/VRAM Usage
        ram                 = true;
        ram_color           = "c26693";
        swap                = true;
        vram                = true;
        # }}}

        battery             = true;       # battery
        time                = true;       # clock

        # {{{ Media PLayer
        media_player        = true;
        media_player_format = "{title};{artist};{album}";
        # }}}
      };
    };
    # }}}

    # {{{ OBS
    obs-studio =
    {
      enable = true;
      plugins = with pkgs.obs-studio-plugins;
      [
        wlrobs
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    };
    # }}}
  };
  # }}}

  # {{{ Qt
  qt =
  {
    enable        = true;
    platformTheme = "qtct";

    # {{{ Qt style
    style =
    {
      package = pkgs.lightly-boehs;
      name    = "Lightly";
    };
    # }}}
  };
  # }}}

  # {{{ Nix packages
  nixpkgs.config.allowUnfree = true;
  # }}}

  # {{{ Services
  services =
  {
    # {{{ MPD
    mpd =                          # music-player for-cantata
    {
      enable = true;

      extraConfig =
      ''
      '';
    };

    mpd-mpris.enable       = true; # for-mpd
    mpd-discord-rpc.enable = true; # for-discord for-mpd
    # }}}

    # {{{ Hyprland Rice
    # {{{ Dunst
    dunst.enable = true;           # hyprland-rice notification-daemon
    # }}}
    # }}}
  };
  # }}}

  # {{{ Hyprland
  wayland.windowManager.hyprland =
  {
    enable = true;
    xwayland.enable = true;
  };
  # }}}

  # {{{ XDG
  xdg =
  {
    enable = true;

    # {{{ Config files
    configFile =
    {
      # {{{ Apply GTK theme to GTK4 apps
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
      # }}}
    };
    # }}}

    # {{{ Portal
    portal =
    {
      enable = true;
      xdgOpenUsePortal = true;

      extraPortals = with pkgs;
      [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];

      # {{{ Config
      config =
      {
        common =
        {
          default =
          [
            "hyprland"
            "gtk"
          ];
        };
      };
      # }}}
    };
    # }}}

    # {{{ User directories
    userDirs =
    {
      enable            = true;
      createDirectories = true;

      desktop           = "${config.xdg.cacheHome}/xdg_desktop_folder"; # I don't need it
      documents         = "${config.home.homeDirectory}/docs";
      download          = "${config.home.homeDirectory}/downs";
      music             = "${config.home.homeDirectory}/music";
      pictures          = "${config.home.homeDirectory}/pics";
      publicShare       = "${config.xdg.dataHome}/xdg_public_folder";
      templates         = "${config.xdg.dataHome}/xdg_templates_folder";
      videos            = "${config.home.homeDirectory}/vids";
    };
    # }}}
  };
  # }}}
}
