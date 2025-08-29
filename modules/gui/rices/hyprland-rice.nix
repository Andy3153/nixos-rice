## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hyprland Rice
## https://github.com/Andy3153/hyprland-rice
##

{ config, lib, pkgs, my-pkgs, ... }:

let
  cfg                   = config.custom.gui.rices.hyprland-rice;

  mainUser              = config.custom.users.mainUser;
  HM                    = config.home-manager.users.${mainUser};
  mkOutOfStoreSymlink   = HM.lib.file.mkOutOfStoreSymlink;

  homeDir               = HM.home.homeDirectory;
  configHome            = HM.xdg.configHome;
  dataHome              = HM.xdg.dataHome;
  hyprlandRiceConfigDir = "${homeDir}/src/hyprland/hyprland-rice/dotconfig";
  hyprlandRiceDataDir   = "${homeDir}/src/hyprland/hyprland-rice/dotlocal/share";
  otherScriptsDir       = "${homeDir}/src/sh/other-shell-scripts";
in
{
  options.custom.gui.rices.hyprland-rice.enable = lib.mkEnableOption "enables my Hyprland rice";

  config = lib.mkIf cfg.enable
  {
    custom =
    {
      gui =
      {
        wm.hyprland.enable = true; # Enable Hyprland

        # {{{ Theming
        theme =
        {
          # {{{ Font
          font =
          {
            generalFontSize = 11;
            fixedFontSize   = 12;

            defaultFonts =
            {
              monospace =
              {
                names    = [ "IosevkaTerm Nerd Font Mono" ];
                #packages = with pkgs; [ (nerdfonts.override{ fonts = [ "IosevkaTerm" "Iosevka" ]; }) ];
                packages = with pkgs.nerd-fonts; [ iosevka iosevka-term ];
              };

              serif =
              {
                names    = config.custom.gui.theme.font.defaultFonts.sansSerif.names;
                packages = config.custom.gui.theme.font.defaultFonts.sansSerif.packages;
              };

              sansSerif =
              {
                names    = [ "Cantarell" ];
                packages = with pkgs; [ cantarell-fonts ];
              };

              emoji =
              {
                names    = [ "Noto Color Emoji" ];
                packages = with pkgs; [ noto-fonts-color-emoji ];
              };
            };
          };
          # }}}

          # {{{ Icons
          icon =
          {
            name    = "Papirus-Dark";
            package = pkgs.catppuccin-papirus-folders.override
            {
              flavor = "mocha";
              accent = "blue";
            };
          };
          # }}}

          # {{{ Cursor
          cursor =
          {
            package = pkgs.apple-cursor;
            name    = "macOS";
            size    = 24;
          };
          # }}}

          # {{{ GTK
          gtk =
          {
            name    = "catppuccin-mocha-blue-standard";
            package = pkgs.catppuccin-gtk.override
            {
              variant = "mocha";
              accents = [ "blue" ];
            };
          };
          # }}}

          # {{{ Qt
          qt =
          {
            platformTheme.qtct =
            {
              enable = true;
              #theme =
              #{
              #  name = "catppuccin-mocha-blue";
              #  package = pkgs.catppuccin-qt5ct;
              #};
            };

            style.kvantum =
            {
              enable = true;
              theme =
              {
                name    = "catppuccin-mocha-blue";
                package = pkgs.catppuccin-kvantum.override
                {
                  variant = "mocha";
                  accent  = "blue";
                };
              };
            };
          };
          # }}}
        };
        # }}}
      };

      # {{{ Extra packages
      extraPackages =
      let
        rofi-dmenu-shim = (pkgs.writeShellScriptBin "dmenu" ''exec ${lib.getExe pkgs.rofi-wayland} -dmenu "$@"'');
        flameshot = (pkgs.flameshot.override { enableWlrSupport = true; });
      in
      lib.lists.flatten
      [
        # {{{ Default NixPkgs
        (with pkgs;
        [
          libcanberra-gtk3                     # hyprland-rice play-system-sounds
          hyprlock                             # hyprland-rice lock-screen
          hyprpicker                           # hyprland-rice color-picker
          hyprsysteminfo                       # hyprland-rice system-info
          dunst                                # hyprland-rice notification-daemon
          wl-clipboard                         # hyprland-rice for-zsh for-nvim clipboard
          wev                                  # hyprland-rice event-viewer
          rofi-wayland                         # hyprland-rice appmenu
          rofi-dmenu-shim                      # hyprland-rice appmenu dmenu-compat
          waycorner                            # hyprland-rice hot-corners
          kitty                                # hyprland-rice terminal
          blueman                              # hyprland-rice bluetooth-control
          networkmanager_dmenu                 # hyprland-rice network-control
          lxqt.pavucontrol-qt                  # hyprland-rice Sound sound-control
          wlr-layout-ui                        # hyprland-rice screen-layout
          nwg-bar                              # hyprland-rice logout-menu
          flameshot                            # hyprland-rice screenshot
          cava                                 # hyprland-rice visualizer
          zathura                              # hyprland-rice pdf-viewer
        ])

        # {{{ KDE packages
        (with pkgs.kdePackages;
        [
          xwaylandvideobridge      # hyprland-rice xwayland-screenshare
          konsole                  # for-dolphin
          kio                      # for-dolphin
          kio-extras               # for-dolphin
          kimageformats            # for-dolphin
          kdegraphics-thumbnailers # for-dolphin

          kcalc                    # hyprland-rice KDE-Apps calculator
          ark                      # hyprland-rice KDE-Apps archive-manager
          gwenview                 # hyprland-rice KDE-Apps image-viewer
          okular                   # hyprland-rice KDE-Apps pdf-viewer
          kcharselect              # hyprland-rice KDE-Apps character-select
          filelight                # hyprland-rice KDE-Apps disk-usage-analyzer
          kruler                   # hyprland-rice KDE-Apps on-screen-ruler
          merkuro                  # hyprland-rice KDE-Apps calendar contacts
        ])
        # }}}
        # }}}

        # {{{ My Nix packages
        (with my-pkgs;
        [
          weather4bar                         # hyprland-rice my-scripts for-waybar
          batnotifsd                          # hyprland-rice my-scripts
        ])
        # }}}
      ];
      # }}}

      # {{{ Programs
      programs =
      {
        dolphin.enable    = true; # hyprland-rice KDE-Apps file-manager
        kdeconnect.enable = true; # hyprland-rice KDE-Apps
        mpv.enable        = true; # hyprland-rice video-player
      };
      # }}}

      # {{{ Unfree package whitelist
      nix.unfreeWhitelist =
      [
        "apple_cursor"
        "corefonts"
        "vista-fonts"
      ];
      # }}}
    };

  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    # {{{ Hyprland
    wayland.windowManager.hyprland =
    {
      enable      = true;

      ##
      ## I do this so that I can have the plugins correctly generated in the
      ## config by Home-Manager, while still maintaining my own hyprland.conf,
      ## because I don't want to write my config files using Home-Manager.
      ##
      extraConfig = "source = ${configHome}/hypr/actual-hyprland.conf";

      plugins = with pkgs.hyprlandPlugins;
      [
        hypr-dynamic-cursors
        hyprspace
        hyprsplit
      ];
    };
    # }}}

    # {{{ Programs
    programs =
    {
      waybar.enable = true; # hyprland-rice desktop-bar
    };
    # }}}

    # {{{ Services
    services =
    {
      hypridle.enable         = true; # hyprland-rice idle-manager
      hyprpaper.enable        = true; # hyprland-rice wallpaper
      hyprpolkitagent.enable  = true; # hyprland-rice polkit-agent
      hyprsunset.enable       = true; # hyprland-rice bluelight-filter
      swayosd.enable          = true; # hyprland-rice osd
      xembed-sni-proxy.enable = true; # hyprland-rice wine-systemtray
    };
    # }}}

    # {{{ Config files
    xdg.configFile =
    {
      "btop".source                                     = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/btop";
      "cava".source                                     = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/cava";
      "css-common".source                               = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/css-common";
      "dunst".source                                    = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/dunst";
      "fastfetch".source                                = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/fastfetch";
      "flameshot".source                                = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/flameshot";
      ##"fontconfig".source                               = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/fontconfig";
      #"fuzzel".source                                   = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/fuzzel";
      ##"gtk-2.0".source                                  = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/gtk-2.0";
      ##"gtk-3.0".source                                  = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/gtk-3.0";
      "htop".source                                     = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/htop";

      "hypr/colorschemes".source                        = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/colorschemes";
      "hypr/hypridle.conf".source                       = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/hypridle.conf";
      "hypr/actual-hyprland.conf".source                = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/hyprland.conf";
      "hypr/hyprlock.conf".source                       = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/hyprlock.conf";
      "hypr/hyprpaper.conf".source                      = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/hyprpaper.conf";
      "hypr/xdph.conf".source                           = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/xdph.conf";

      "kitty".source                                    = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/kitty";
      #"lf".source                                       = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/lf";
      "mpv".source                                      = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/mpv";
      "networkmanager-dmenu".source                     = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/networkmanager-dmenu";
      "nwg-bar".source                                  = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/nwg-bar";
      #"nwg-dock-hyprland".source                        = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/nwg-dock-hyprland";
      #"nwg-drawer".source                               = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/nwg-drawer";
      ##"qt5ct".source                                    = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/qt5ct";
      ##"qt6ct".source                                    = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/qt5ct";
      "rofi".source                                     = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/rofi";
      #"swayidle".source                                 = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/swayidle";
      #"swaylock".source                                 = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/swaylock";
      #"swaync".source                                   = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/swaync";
      "waybar".source                                   = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/waybar";
      "waycorner".source                                = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/waycorner";
      #"xava".source                                     = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/xava";
      "xdg-desktop-portal/hyprland-portals.conf".source = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/xdg-desktop-portal/hyprland-portals.conf";
      "xdg-desktop-portal/Hyprland-portals.conf".source = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/xdg-desktop-portal/hyprland-portals.conf";
      "xdg-desktop-portal/portals.conf".source          = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/xdg-desktop-portal/hyprland-portals.conf";
      "zathura".source                                  = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/zathura";
    };
    # }}}

    # {{{ Data files
    xdg.dataFile =
    {
      "sounds".source             = mkOutOfStoreSymlink "${hyprlandRiceDataDir}/sounds";
      "wallpapers".source         = mkOutOfStoreSymlink "${hyprlandRiceDataDir}/wallpapers";

      "wallpaper.png".source      = mkOutOfStoreSymlink "${hyprlandRiceDataDir}/wallpaper.png";      # these basically set your wallpaper
      "wallpaper-lock.png".source = mkOutOfStoreSymlink "${hyprlandRiceDataDir}/wallpaper-lock.png";
    };
    # }}}

    # {{{ Scripts
    home.file =
    {
      "${dataHome}/../bin/checkFan.sh".source         = mkOutOfStoreSymlink "${otherScriptsDir}/checkFan.sh";
      "${dataHome}/../bin/launch-waybar".source       = mkOutOfStoreSymlink "${otherScriptsDir}/launch-waybar";
      "${dataHome}/../bin/suspend_compositing".source = mkOutOfStoreSymlink "${otherScriptsDir}/suspend_compositing";
      "${dataHome}/../bin/dunst-dnd-toggle".source    = mkOutOfStoreSymlink "${otherScriptsDir}/dunst-dnd-toggle";
    };
    # }}}
  };
  # }}}
  };
}
