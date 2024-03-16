## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Home Manager configuration by Andy3153
## created   03/09/23 ~ 16:57:11
## rewrote   15/03/24 ~ 17:06:25
##

{ config, pkgs, ... }:

{
  news.display = "notify";

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
      libcanberra-gtk3           # hyprland-rice play-system-sounds
      hyprpaper                  # hyprland-rice wallpaper
      hypridle                   # hyprland-rice idle-manager
      hyprlock                   # hyprland-rice lock-screen
      hyprpicker                 # hyprland-rice color-picker
      wl-clipboard               # for-nvim hyprland-rice clipboard
      swayosd                    # hyprland-rice osd
      polkit-kde-agent           # hyprland-rice polkit-agent
      xwaylandvideobridge        # hyprland-rice xwayland-screenshare
      rofi-wayland               # hyprland-rice appmenu
      kitty                      # hyprland-rice terminal
      waybar                     # hyprland-rice status-bar
      dunst                      # hyprland-rice notification-daemon
      blueman                    # hyprland-rice bluetooth-control
      networkmanager_dmenu       # hyprland-rice network-control
      lxqt.pavucontrol-qt        # hyprland-rice Sound sound-control
      nwg-bar                    # hyprland-rice logout-menu
      flameshot                  # hyprland-rice screenshot
      grim                       # hyprland-rice screenshot for-flameshot
      slurp                      # hyprland-rice screenshot for-flameshot

      mpv                        # hyprland-rice video-player
      mpvScripts.mpris           # hyprland-rice for-mpv

      zathura                    # pdf-viewer

      kcalc                      # hyprland-rice KDE-Apps calculator
      kdePackages.kdeconnect-kde # hyprland-rice KDE-Apps
      dolphin                    # hyprland-rice KDE-Apps file-manager
      ark                        # hyprland-rice KDE-Apps archive-manager
      gwenview                   # hyprland-rice KDE-Apps image-viewer
      okular                     # hyprland-rice KDE-Apps pdf-viewer
      kcharselect                # hyprland-rice KDE-Apps character-select
      filelight                  # hyprland-rice KDE-Apps disk-usage-analyzer
      kdePackages.kruler         # hyprland-rice KDE-Apps on-screen-ruler
      merkuro                    # hyprland-rice KDE-Apps calendar contacts
      # }}}

      extest                     # for-steam controller
      yt-dlp                     # download

      qpwgraph                   # Sound PipeWire Patchbay
      easyeffects                # Sound PipeWire
      pulsemixer                 # Sound sound-control

      linux-wifi-hotspot         # Internet hotspot

      gparted                    # Partition-Manager

      okteta                     # KDE-Apps hex-editor

      mousai                     # GNOME-Apps song-identifier

      libreoffice-fresh          # Office
      gimp                       # Office photo-editing
      inkscape                   # Office photo-editing

      pdftk                      # pdf-tools
      pdfarranger                # pdf-tools
    ];
    # }}}

    # {{{ File
    file =
    {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
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

  # {{{ Services
  services =
  {
    # {{{ Hyprland Rice
    # {{{ Dunst
    #dunst.enable = true;   # hyprland-rice notification-daemon
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
