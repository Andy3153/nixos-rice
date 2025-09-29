## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Yazi config
##

{ config, options, lib, pkgs, ... }:

let
  cfg    = config.custom.programs.yazi;
  cfgGui = config.custom.gui;

  mainUser            = config.custom.users.mainUser;
  HM                  = config.home-manager.users.${mainUser};
  mkOutOfStoreSymlink = HM.lib.file.mkOutOfStoreSymlink;

  homeDir               = HM.home.homeDirectory;
  hyprlandRiceConfigDir = "${homeDir}/src/hyprland/hyprland-rice/dotconfig";
in
{
  options.custom.programs.yazi =
  {
    enable              = lib.mkEnableOption "enables Yazi";
    enableCustomConfigs = lib.mkEnableOption "enable my custom configs";

    flavors = lib.mkOption
    {
      type        = options.programs.yazi.flavors.type;
      default     = options.programs.yazi.flavors.default;
      example     = options.programs.yazi.flavors.example;
      description = "Yazi flavors (themes) to install";
    };

    plugins = lib.mkOption
    {
      type        = options.programs.yazi.plugins.type;
      default     = options.programs.yazi.plugins.default;
      example     = options.programs.yazi.plugins.example;
      description = "Yazi plugins to install";
    };
  };

  config = lib.mkIf cfg.enable
  {
    # {{{ Packages
    custom.extraPackages = lib.lists.flatten
    [
      (with pkgs;
      [
        p7zip
        jq
        fd
        ripgrep
        fzf
      ])

      (if cfg.enableCustomConfigs then with pkgs;
      [
      ] else [])

      (if cfgGui.enable then with pkgs;
      [
        ffmpeg
        poppler
        resvg
        imagemagick
        wl-clipboard
      ] else [])
    ];
    # }}}

    # {{{ Yazi program
    programs.yazi =
    {
      enable  = true;
      flavors = cfg.flavors;
      plugins = cfg.plugins;
    };
    # }}}

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      # {{{ Yazi program
      programs.yazi =
      {
        enable               = true;
        enableZshIntegration = config.custom.programs.zsh.enable;
        flavors              = cfg.flavors;
        plugins              = cfg.plugins;
      };
      # }}}

      # {{{ Config files
      xdg.configFile = lib.mkIf cfg.enableCustomConfigs
      {
        "yazi".source = mkOutOfStoreSymlink "${hyprlandRiceConfigDir}/yazi";
        "yazi".recursive = true;
      };
      # }}}
    };
    # }}}
  };
}
