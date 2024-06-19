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
