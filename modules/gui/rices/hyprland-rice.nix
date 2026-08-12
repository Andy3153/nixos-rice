## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Hyprland Rice
## https://github.com/Andy3153/hyprland-rice
##

{ config, lib, pkgs, my-pkgs, ... }:

# {{{ Variables
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

  # {{{ XDG portal configuration
  portalConfig = rec
  {
    config = rec
    {
      common =
      {
        default = [ "hyprland" "gtk" ];
        #"org.freedesktop.impl.portal.FileChooser" = "kde";
      };

      hyprland = common;
      Hyprland = common;
    };

    configPackages = with pkgs;
    [
      #kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];

    extraPortals = configPackages;
  };
  # }}}
in
# }}}
{
  options.custom.gui.rices.hyprland-rice.enable = lib.mkEnableOption "enables my Hyprland rice";

  # {{{ Config
  config = lib.mkIf cfg.enable
  {
    custom =
    {
      gui =
      {
        dm.plasma-login-manager.enable = true;
        wm.hyprland.enable             = true;

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
            platformTheme.qtct.enable = true;

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
        rofi-dmenu-shim = (pkgs.writeShellScriptBin "dmenu" ''exec ${lib.getExe pkgs.rofi} -dmenu "$@"'');
        flameshot = (pkgs.flameshot.override { enableWlrSupport = true; });
      in
      lib.lists.flatten
      [
        # {{{ Default NixPkgs
        (with pkgs;
        [
          blueman              # hyprland-rice bluetooth-control
          cava                 # hyprland-rice visualizer
          cliphist             # hyprland-rice clipboard-manager
          dunst                # hyprland-rice notification-daemon
          flameshot            # hyprland-rice screenshot
          hyprlock             # hyprland-rice lock-screen
          hyprpicker           # hyprland-rice color-picker
          hyprshutdown         # hyprland-rice shutdown
          hyprsysteminfo       # hyprland-rice system-info
          kitty                # hyprland-rice terminal
          libcanberra-gtk3     # hyprland-rice play-system-sounds
          lua                  # hyprland-rice lua
          lxqt.pavucontrol-qt  # hyprland-rice Sound sound-control
          networkmanager_dmenu # hyprland-rice network-control
          rofi                 # hyprland-rice appmenu
          rofi-dmenu-shim      # hyprland-rice appmenu dmenu-compat
          wev                  # hyprland-rice event-viewer
          wl-clipboard         # hyprland-rice for-zsh for-nvim clipboard
          wleave               # hyprland-rice logout-menu
          wlr-layout-ui        # hyprland-rice screen-layout
          zathura              # hyprland-rice pdf-viewer
        ])

        # {{{ KDE packages
        (with pkgs.kdePackages;
        [
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
          weather4bar # hyprland-rice my-scripts for-waybar
          batnotifsd  # hyprland-rice my-scripts
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

      # {{{ Systemd
      systemd.user.services =
      {
        audioInputMute.enable              = true;
        audioInputSetDefaultVolume.enable  = true;
        audioOutputSetDefaultVolume.enable = true;
        audioOutputUnmute.enable           = true;
        startupSound.enable                = true;
      };
      # }}}
    };

    xdg.portal = portalConfig;

  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    # {{{ Hyprland
    wayland.windowManager.hyprland =
    {
      enable = true;
      configType = "lua";

      ##
      ## I do this so that I can have the plugins correctly generated in the
      ## config by Home-Manager, while still maintaining my own hyprland.lua,
      ## because I don't want to write my config files using Home-Manager.
      ##
      extraConfig = ''require("actual-hyprland")'';

      plugins = with pkgs.hyprlandPlugins;
      [
        #hypr-dynamic-cursors
        #hyprsplit
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
      "btop".source       = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/btop";
      "cava".source       = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/cava";
      "css-common".source = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/css-common";
      "dunst".source      = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/dunst";
      "fastfetch".source  = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/fastfetch";
      "flameshot".source  = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/flameshot";
      "htop".source       = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/htop";

      "hypr/colorschemes".source        = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/colorschemes";
      "hypr/lua".source                 = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/lua";
      "hypr/hypridle.conf".source       = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/hypridle.conf";
      "hypr/actual-hyprland.lua".source = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/hyprland.lua";
      "hypr/hyprlock.conf".source       = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/hyprlock.conf";
      "hypr/hyprpaper.conf".source      = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/hyprpaper.conf";
      "hypr/hyprtoolkit.conf".source    = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/hyprtoolkit.conf";
      "hypr/xdph.conf".source           = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/hypr/xdph.conf";

      "kitty".source                = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/kitty";
      "mpv".source                  = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/mpv";
      "networkmanager-dmenu".source = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/networkmanager-dmenu";
      "rofi".source                 = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/rofi";
      "waybar".source               = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/waybar";
      "wleave".source               = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/wleave";
      "zathura".source              = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/zathura";
    };
    # }}}

    # {{{ Data files
    xdg.dataFile =
    {
      "sounds".source             = mkOutOfStoreSymlink "${hyprlandRiceDataDir}/sounds";
      "wallpapers".source         = mkOutOfStoreSymlink "${hyprlandRiceDataDir}/wallpapers";
      "user-icons".source         = mkOutOfStoreSymlink "${hyprlandRiceDataDir}/user-icons";

      "wallpaper.png".source      = mkOutOfStoreSymlink "${hyprlandRiceDataDir}/wallpaper.png";      # these basically set your wallpaper
      "wallpaper-lock.png".source = mkOutOfStoreSymlink "${hyprlandRiceDataDir}/wallpaper-lock.png";
    };
    # }}}

    # {{{ Home files
    home.file =
    {
      ".face.icon".source                             = mkOutOfStoreSymlink "${dataHome}/user-icons/${mainUser}.png";
      "${dataHome}/../bin/checkFan.sh".source         = mkOutOfStoreSymlink "${otherScriptsDir}/checkFan.sh";
      "${dataHome}/../bin/launch-waybar".source       = mkOutOfStoreSymlink "${otherScriptsDir}/launch-waybar";
      "${dataHome}/../bin/suspend_compositing".source = mkOutOfStoreSymlink "${otherScriptsDir}/suspend_compositing";
      "${dataHome}/../bin/dunst-dnd-toggle".source    = mkOutOfStoreSymlink "${otherScriptsDir}/dunst-dnd-toggle";
    };
    # }}}

    xdg.portal = portalConfig;
  };
  # }}}
  };
  # }}}
}
