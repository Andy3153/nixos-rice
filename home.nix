## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Home Manager configuration by Andy3153
## created   03/09/23 ~ 16:57:11
## rewrote   15/03/24 ~ 17:06:25
##

{ lib, pkgs, pkgs-stable, ... }:

{
  news.display = "notify"; # Show news

  # {{{ Home
  home =
  {
    # {{{ Packages
    packages = lib.mkMerge
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
      ])
      # }}}

      # {{{ NixPkgs 24.05
      (with pkgs-stable;
      [
      ])
      # }}}
    ];
    # }}}

    # {{{ File
    file =
    {
      # {{{ Zsh
      ".config/zsh".source = /home/andy3153/src/sh/andy3153-zshrc;
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
  };
  # }}}
}
