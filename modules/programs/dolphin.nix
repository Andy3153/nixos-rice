## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Dolphin config
##

{ config, lib, pkgs, ... }:

# {{{ Variables
let
  cfg      = config.custom.programs.dolphin;
  mainUser = config.custom.users.mainUser;

  qtStyle   = config.custom.gui.theme.qt.style.name;

  # {{{ Dolphin config
  dolphinConf =
  {
    ContentDisplay =
    {
      DirectorySizeMode    = "ContentSize";
      UsePermissionsFormat = "NumericFormat";
    };

    ContextMenu.ShowCopyMoveMenu = true;
    DetailsMode.PreviewSize = 22;

    General =
    {
      AlwaysShowTabBar            = true;
      GlobalViewProps             = false;
      ShowStatusBar               = "FullWidth";
      ShowToolTips                = true;
      ShowZoomSlider              = true;
      UseTabForSwitchingSplitView = true;
    };

    "KFileDialog Settings" =
    {
      "Places Icons Auto-resize" = false;
      "Places Icons Static Size" = 22;
    };

    MainWindow.MenuBar = "Disabled";

    PreviewSettings.Plugins = "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,textthumbnail";

    UiSettings.ColorScheme = lib.mkIf (qtStyle != null) qtStyle;
  };
  # }}}
in
# }}}
{
  # {{{ Options
  options.custom.programs.dolphin =
  {
    enable = lib.mkEnableOption "enables Dolphin";

    settings = lib.mkOption
    {
      type = lib.types.anything;
      default = dolphinConf;
      example = dolphinConf;
      description = "Dolphin settings that will be placed under ~/.config/dolphinrc";
    };
  };
  # }}}

  # {{{ Config
  config = lib.mkIf cfg.enable
  {
    custom =
    {
      extraPackages = with pkgs.kdePackages;
      [
        dolphin
        kservice
      ];

      programs.dolphin.settings = dolphinConf;
    };

    # {{{ MIME associations fix
    ##
    ## Fixes a bug which makes the "Open With" menu empty, at the expense of
    ## pulling the entirety of plasma-workspace inside of the nix store.
    ##
    ## https://discourse.nixos.org/t/dolphin-does-not-have-mime-associations/48985/8
    ##
    environment.etc."/xdg/menus/applications.menu".text = builtins.readFile
     "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    # }}}

  # {{{ Home-Manager
  home-manager.users.${mainUser} =
  {
    # {{{ Config files
    xdg.configFile =
    {
      "dolphinrc".text = lib.generators.toINI { } cfg.settings;
    };
    # }}}
  };
  # }}}
  };
  # }}}
}
