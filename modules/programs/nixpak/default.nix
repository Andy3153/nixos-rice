## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixPak bundle
##

{ config, inputs, lib, pkgs, ... }:

let
  systemFonts = config.fonts.packages;
  systemTheme = config.custom.gui.theme;
  systemEnv   = config.environment.variables;
in
{
  _module.args.nixpakCustom =
  {
    # {{{ Options
    opts = { config, sloth, ... }:
    let
      cfg = config.custom;
    in
    {
      options.custom =
      {
        gpu.enable     = lib.mkEnableOption "enable GPU support in programs";
        gui.enable     = lib.mkEnableOption "enable GUI support in programs";
        network.enable = lib.mkEnableOption "enable network support in programs";
        sound.enable   = lib.mkEnableOption "enable sound support in programs";
      };

      config = lib.mkMerge
      [
        { locale.enable = true; }

        # {{{ GPU
        (lib.mkIf cfg.gpu.enable
        {
          bubblewrap.bind.dev = [ "/dev/dri" ];

          gpu =
          {
            enable   = true;
            provider = "bundle";
          };
        })
        # }}}

        # {{{ GUI
        (lib.mkIf cfg.gui.enable
        {
          # {{{ Bubblewrap
          bubblewrap =
          {
            sockets.wayland = true;

            # {{{ Directory bind
            bind =
            {
              # {{{ Read-only
              ro =
              [
                (sloth.concat' sloth.runtimeDir    "/doc")
                (sloth.concat' sloth.xdgConfigHome "/Kvantum")
                (sloth.concat' sloth.xdgConfigHome "/fontconfig")
                (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
                (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
                (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
                (sloth.concat' sloth.xdgConfigHome "/qt5ct")
                (sloth.concat' sloth.xdgConfigHome "/qt6ct")
                (sloth.concat' sloth.xdgDataHome   "/icons")
                (sloth.concat' sloth.xdgDataHome   "/themes")
              ];
              # }}}

              # {{{ Read-write
              rw =
              [
                [
                  sloth.appCacheDir
                  sloth.xdgCacheHome
                ]
                (sloth.concat' sloth.xdgCacheHome "/fontconfig")
                (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")

                (sloth.concat' sloth.runtimeDir "/at-spi/bus")
                (sloth.concat' sloth.runtimeDir "/gvfsd")

                [
                  (sloth.mkdir (sloth.concat [
                    sloth.appCacheDir
                    "/nixpak-app-shared-tmp"
                  ]))
                  "/tmp"
                ]
              ];
              # }}}
            };
            # }}}

            # {{{ Environment variables
            env =
            {
              QT_QPA_PLATFORMTHEME = systemEnv.QT_QPA_PLATFORMTHEME;
              QT_STYLE_OVERRIDE    = systemEnv.QT_STYLE_OVERRIDE;

              XDG_DATA_DIRS = lib.makeSearchPath "share"
              [
                systemTheme.cursor.package
                systemTheme.gtk.package
                pkgs.adwaita-icon-theme
                pkgs.shared-mime-info
              ];

              XCURSOR_PATH = lib.concatStringsSep ":"
              [
                "${systemTheme.cursor.package}/share/icons"
                "${systemTheme.cursor.package}/share/pixmaps"

                "${systemTheme.gtk.package}/share/icons"
                "${systemTheme.gtk.package}/share/pixmaps"

                "${pkgs.adwaita-icon-theme}/share/icons"
                "${pkgs.adwaita-icon-theme}/share/pixmaps"
              ];
            };
            # }}}
          };
          # }}}

          # {{{ DBus
          dbus.policies =
          {
            "${config.flatpak.appId}"  = "own";
            "ca.desrt.dconf"           = "talk";
            "org.a11y.Bus"             = "talk";
            "org.freedesktop.DBus"     = "talk";
            "org.freedesktop.portal.*" = "talk";
            "org.gtk.vfs"              = "talk";
            "org.gtk.vfs.*"            = "talk";
          };
          # }}}

          # {{{ Fonts
          fonts =
          {
            enable = true;
            fonts  = systemFonts;
          };
          # }}}
        })
        # }}}

        # {{{ Network
        #(lib.mkIf cfg.network.enable
        {
          bubblewrap.network         = cfg.network.enable;
          etc.sslCertificates.enable = cfg.network.enable;
        }#)
        # }}}

        # {{{ Sound
        #(lib.mkIf cfg.sound.enable
        {
          bubblewrap.sockets =
          {
            pipewire = cfg.sound.enable;
            pulse    = cfg.sound.enable;
          };
        }#)
        # }}}
      ];
    };
    # }}}

    # {{{ mkNixPak
    mkNixPak = inputs.nixpak_unstable.lib.nixpak
    {
      inherit (pkgs) lib;
      inherit pkgs;
    };
    # }}}
  };
}
