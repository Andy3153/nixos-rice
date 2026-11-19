## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Package groups
##

{ pkgs, ... }:
{
  _module.args.pkgGroups = with pkgs;
  {
    # {{{ 3D
    _3d =
    [
      blender
    ];
    # }}}

    # {{{ Browsers
    browsers =
    [
      tor-browser        # Tor
      ungoogled-chromium # browser
    ];
    # }}}

    # {{{ Filesystems
    fs =
    [
      gparted # Partition-Manager
      fatsort # Filesystems sort-fat-fs

      (testdisk.override
      {
        enableQt = true;
        enableNtfs = true;
        enableExtFs = true;
      })

      f3 # flash-drive-tester
    ];
    # }}}

    # {{{ Gaming
    gaming =
    {
      # {{{ Emulators
      emulators =
      [
        dolphin-emu # emulators games gc wii
      ];
      # }}}

      # {{{ Games
      games =
      [
        beammp-launcher     # for-beamng
        osu-lazer-bin       # games
        prismlauncher       # games
        space-cadet-pinball # games
      ];
      # }}}

      # {{{ Launchers
      launchers =
      [
        heroic # launchers games
        lutris # launchers for-wine
      ];
      # }}}
    };
    # }}}

    # {{{ Media
    media =
    {
      # {{{ Audio
      audio =
      {
        # {{{ Convert
        convert =
        [
          flac       # music
          opus-tools # music
          shntool    # music split-cue
          cdparanoia # music rip-cds
        ];
        # }}}

        # {{{ Edit
        edit =
        [
          audacity # audio-editor
        ];
        # }}}

        # {{{ Play
        play =
        [
          pear-desktop # music-player youtube-music
        ];
        # }}}

        # {{{ Tools
        tools =
        [
          mousai # music find-music
          picard # music tag-music
          lrcget # music get-lyrics
        ];
        # }}}
      };
      # }}}

      # {{{ Image
      image =
      {
        # {{{ Convert
        convert =
        [
          exiftool # image-data
        ];
        # }}}

        # {{{ Edit
        edit =
        [
          gimp3-with-plugins # Office photo-editing
          inkscape           # Office photo-editing
        ];
        # }}}

        # {{{ Edit extras
        editExtras =
        [
          krita # Office photo-editing
        ];
        # }}}
      };
      # }}}

      # {{{ Convert
      convert =
      [
        ffmpeg # media-convert
      ];
      # }}}

      # {{{ Download
      download =
      [
        yt-dlp # media-download
      ];
      # }}}
    };
    # }}}

    # {{{ Office
    office =
    {
      # {{{ WYSIWYG
      wysiwyg =
      [
        libreoffice-qt6 # Office
      ];
      # }}}

      # {{{ LaTeX
      latex =
      [
        texliveFull                # LaTeX
        texpresso                  # for-latex
        python314Packages.pygments # for-latex
        pandoc                     # for-latex
        ghostscript                # for-latex pdf-tools
      ];
      # }}}

      # {{{ PDF
      pdf =
      [
        pdftk         # pdf-tools
        pdfarranger   # pdf-tools
        poppler-utils # pdf-tools
      ];
      # }}}
    };
    # }}}

    # {{{ Programming
    programming =
    [
      gh # github for-git
    ];
    # }}}

    # {{{ Social
    social =
    [
      ferdium # Social
    ];
    # }}}

    # {{{ Wine
    wine =
    let
      bottles = pkgs.bottles.override { removeWarningPopup = true; };
    in
    [
      wineWow64Packages.staging # wine
      bottles                   # launchers for-wine
    ];
    # }}}
  };
}
