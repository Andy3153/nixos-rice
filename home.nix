## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Home Manager configuration by Andy3153
## created   03/09/23 ~ 16:57:11
## rewrote   15/03/24 ~ 17:06:25
##

{ config, pkgs, ... }: #pkgs-unstable, ... }:

{
  news.display = "notify"; # Show news

  # {{{ GTK
  gtk =
  {
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
  };
  # }}}

  # {{{ Home
  home =
  {
    # {{{ Packages
    packages = with pkgs;
    [
      # {{{ Hyprland Rice
      libcanberra-gtk3                    # hyprland-rice play-system-sounds
      hyprpaper                           # hyprland-rice wallpaper
      hypridle                            # hyprland-rice idle-manager
      hyprlock                            # hyprland-rice lock-screen
      hyprpicker                          # hyprland-rice color-picker
      swayosd                             # hyprland-rice osd
      polkit-kde-agent                    # hyprland-rice polkit-agent
      xwaylandvideobridge                 # hyprland-rice xwayland-screenshare
      wev                                 # hyprland-rice event-viewer
      rofi-wayland                        # hyprland-rice appmenu
      kitty                               # hyprland-rice terminal
      waybar                              # hyprland-rice status-bar
      blueman                             # hyprland-rice bluetooth-control
      networkmanager_dmenu                # hyprland-rice network-control
      lxqt.pavucontrol-qt                 # hyprland-rice Sound sound-control
      nwg-bar                             # hyprland-rice logout-menu
      flameshot                           # hyprland-rice screenshot
      grim                                # hyprland-rice screenshot for-flameshot
      slurp                               # hyprland-rice screenshot for-flameshot

      mpv                                 # hyprland-rice video-player
      mpvScripts.mpris                    # hyprland-rice for-mpv

      zathura                             # hyprland-rice pdf-viewer

      kcalc                               # hyprland-rice KDE-Apps calculator
      kdePackages.kdeconnect-kde          # hyprland-rice KDE-Apps
      #kdePackages.dolphin                 # hyprland-rice KDE-Apps file-manager
      dolphin                             # hyprland-rice KDE-Apps file-manager
      ark                                 # hyprland-rice KDE-Apps archive-manager
      gwenview                            # hyprland-rice KDE-Apps image-viewer
      okular                              # hyprland-rice KDE-Apps pdf-viewer
      kcharselect                         # hyprland-rice KDE-Apps character-select
      filelight                           # hyprland-rice KDE-Apps disk-usage-analyzer
      kdePackages.kruler                  # hyprland-rice KDE-Apps on-screen-ruler
      merkuro                             # hyprland-rice KDE-Apps calendar contacts
      # }}}

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
      ffmpeg                              # music video
      audacity                            # music
      mousai                              # find music
      # }}}

      # {{{ Games
      depotdownloader                     # for-steam
      extest                              # for-steam for-controllers
      wineWowPackages.staging             # wine
      protonup-qt                         # for-steam for-wine
      protontricks                        # for-steam for-wine

      bottles                             # for-wine
      lutris                              # for-wine

      prismlauncher                       # games
      xonotic                             # games

      mesa-demos                          # glxgears
      # }}}

      # {{{ For Neovim
      neovide                             # for-nvim

      # {{{ LSPs
      arduino-language-server             # Programming for-nvim for-lsp
      nodePackages.bash-language-server   # Programming for-nvim for-lsp
      clang-tools                         # Programming for-nvim for-lsp
      cmake-language-server               # Programming for-nvim for-lsp
      dockerfile-language-server-nodejs   # Programming for-nvim for-lsp
      lua-language-server                 # Programming for-nvim for-lsp
      marksman                            # Programming for-nvim for-lsp
      nil                                 # Programming for-nvim for-lsp
      python311Packages.python-lsp-server # Programming for-nvim for-lsp
      texlab                              # Programming for-nvim for-lsp
      nodePackages.vim-language-server    # Programming for-nvim for-lsp
      # }}}

      # {{{ For LSPs
      #cargo                               # Programming for-nvim for-lsp
      #rustc                               # Programming for-nvim for-lsp
      # }}}
      # }}}

      # {{{ Fonts
      corefonts                           # fonts ms-fonts
      vistafonts                          # fonts ms-fonts
      # }}}

      # {{{ 3D
      blender                             # 3D
      # }}}

      yt-dlp                              # download
      linux-wifi-hotspot                  # Internet hotspot
      gparted                             # Partition-Manager
      okteta                              # KDE-Apps hex-editor
      mousai                              # GNOME-Apps song-identifier
      betterdiscordctl                    # for-discord
      virt-manager                        # for-libvirt
      virtiofsd                           # for-libvirt
      qbittorrent                         # torrents

      ventoy-full
    ];
    # }}}

    # {{{ File
    file =
    {
      # {{{ Zsh
      ".config/zsh".source = /home/andy3153/src/sh/andy3153-zshrc;
      # }}}

      # {{{ Neovim
      ".config/nvim".source    = /home/andy3153/src/nvim/andy3153-init.lua;
      ".config/nvim".recursive = true; # because packer creates some files in the nvim folder
      # }}}

      # {{{ Hyprland Rice
      ".config/btop".source                      = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/btop;
      #".config/cava".source                      = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/cava;
      ".config/css-common".source                = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/css-common;
      ".config/dunst".source                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/dunst;
      ".config/fastfetch".source                 = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/fastfetch;
      ".config/flameshot".source                 = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/flameshot;
      ##".config/fontconfig".source                = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/fontconfig;
      #".config/fuzzel".source                    = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/fuzzel;
      ##".config/gtk-2.0".source                   = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/gtk-2.0;
      ##".config/gtk-3.0".source                   = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/gtk-3.0;
      ".config/htop".source                      = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/htop;
      ".config/hypr".source                      = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/hypr;
      ".config/kitty".source                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/kitty;
      #".config/lf".source                        = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/lf;
      ".config/mpv".source                       = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/mpv;
      ".config/networkmanager-dmenu".source      = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/networkmanager-dmenu;
      ".config/nwg-bar".source                   = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/nwg-bar;
      #".config/nwg-dock-hyprland".source         = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/nwg-dock-hyprland;
      #".config/nwg-drawer".source                = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/nwg-drawer;
      ##".config/qt5ct".source                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/qt5ct;
      ##".config/qt6ct".source                     = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/qt5ct;
      ".config/rofi".source                      = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/rofi;
      #".config/swayidle".source                  = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/swayidle;
      #".config/swaylock".source                  = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/swaylock;
      #".config/swaync".source                    = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/swaync;
      ".config/waybar".source                    = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/waybar;
      #".config/xava".source                      = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/xava;
      ".config/zathura".source                   = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/zathura;

      ".local/share/sounds".source               = /home/andy3153/src/hyprland/hyprland-rice/dotlocal/share/sounds;
      ".local/share/wallpapers".source           = /home/andy3153/src/hyprland/hyprland-rice/dotlocal/share/wallpapers;
      ".local/share/wallpaper.png".source        = /home/andy3153/src/hyprland/hyprland-rice/dotlocal/share/wallpapers/wallpaper5.png;
      ".local/share/wallpaper-lock.png".source   = /home/andy3153/src/hyprland/hyprland-rice/dotlocal/share/wallpapers/wallpaper5.png;

      ".local/bin/suspend_compositing.sh".source = /home/andy3153/src/hyprland/hyprland-rice/dotconfig/hypr/scripts/suspend_compositing.sh;
      # }}}

      # {{{ For Flatpak
      #".local/share/fonts".source = /run/current-system/sw/share/X11/fonts;
      #".local/share/icons".source = /run/current-system/sw/share/icons;
      # }}}
    };
    # }}}
  };
  # }}}

  # {{{ Programs
  programs =
  {
    home-manager.enable = true; # let HM manage itself

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

        battery             = true;
        time                = true;

        # {{{ Media Player
        media_player        = true;
        media_player_format = "{title};{artist};{album}";
        # }}}
      };
    };
    # }}}
  };
  # }}}

  # {{{ Qt
  qt =
  {
    enable             = true;
    platformTheme.name = "qtct";

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

  # {{{ XDG
  xdg =
  {
    enable = true;

    # {{{ Config files
    configFile =
    let
      # {{{ QTCT config
      # Get the colorscheme
      # Catppuccin Mocha
      colorScheme = pkgs.fetchurl
      {
        url  = "https://raw.githubusercontent.com/catppuccin/qt5ct/main/themes/Catppuccin-Mocha.conf";
        hash = "sha256-NKrzBU9fvchVP2UFuFPNnCYlW/YDPdiwniao0KQOMBs=";
      };

      qtctConf =
      ''
        [Appearance]
        style=${config.qt.style.name}
        icon_theme=${config.gtk.iconTheme.name}
        color_scheme_path=${colorScheme}
        custom_palette=true
        standard_dialogs=xdgdesktopportal

        [Fonts]
        general="${config.gtk.font.name},${builtins.toString config.gtk.font.size},-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
        fixed="IosevkaTerm NF,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"

        [Interface]
        activate_item_on_single_click=1
        buttonbox_layout=2
        cursor_flash_time=1000
        dialog_buttons_have_icons=1
        double_click_interval=400
        gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
        keyboard_scheme=3
        menus_have_icons=true
        show_shortcuts_in_context_menus=true
        stylesheets=@Invalid()
        toolbutton_style=4
        underline_shortcut=1
        wheel_scroll_lines=3
      '';
      # }}}
    in
    {
      # {{{ Dealing with QTCT
      "qt5ct/qt5ct.conf".text = qtctConf;
      "qt6ct/qt6ct.conf".text = qtctConf;
      # }}}
    };
    # }}}
  };
  # }}}
}
