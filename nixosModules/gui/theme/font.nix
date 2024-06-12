## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Font config
##

{ config, lib, ... }:

let
  cfg = config.custom.gui.theme.font;
  fontModule = lib.types.submodule
  {
    options =
    {
      size = lib.mkOption
      {
        type        = lib.types.int;
        default     = 11;
        example     = 12;
        description = "font size in GUI programs";
      };

      extraFontPackages = lib.mkOption
      {
        type        = lib.types.listOf lib.types.path;
        default     = [];
        description = "list of extra font packages";
      };

      defaultFonts =
      {
        monospace =
        {
          names = lib.mkOption
          {
            type        = lib.types.listOf lib.types.str;
            default     = [ "DejaVu Sans Mono" ];
            description = "default monospace font(s)";
          };

          packages = lib.mkOption
          {
            type        = lib.types.listOf lib.types.path;
            description = "default monospace font(s) package(s)";
          };
        };

        serif =
        {
          names = lib.mkOption
          {
            type        = lib.types.listOf lib.types.str;
            default     = [ "DejaVu Serif" ];
            description = "default serif font(s)";
          };

          packages = lib.mkOption
          {
            type        = lib.types.listOf lib.types.path;
            description = "default serif font(s) package(s)";
          };
        };

        sansSerif =
        {
          names = lib.mkOption
          {
            type        = lib.types.listOf lib.types.str;
            default     = [ "DejaVu Sans" ];
            description = "default sans-serif font(s)";
          };

          packages = lib.mkOption
          {
            type        = lib.types.listOf lib.types.path;
            description = "default sans-serif font(s) package(s)";
          };
        };

        emoji =
        {
          names = lib.mkOption
          {
            type        = lib.types.listOf lib.types.str;
            default     = [ "Noto Color Emoji" ];
            description = "default emoji font(s)";
          };

          packages = lib.mkOption
          {
            type        = lib.types.listOf lib.types.path;
            description = "default emoji font(s) package(s)";
          };
        };
      };
    };
  };
in
{
  options.custom.gui.theme.font = lib.mkOption
  {
    type        = lib.types.nullOr fontModule;
    default     = lib.types.null;
    description = "font configuration";
  };

  config = lib.mkIf (cfg != null)
  {
    fonts =
    {
      enableDefaultPackages = lib.mkDefault true;
      fontDir.enable        = lib.mkDefault true;
      packages              =
        cfg.defaultFonts.monospace.packages ++
        cfg.defaultFonts.serif.packages     ++
        cfg.defaultFonts.sansSerif.packages ++
        cfg.defaultFonts.emoji.packages     ++
        cfg.extraFontPackages;

      fontconfig =
      {
        enable = lib.mkDefault true;
        defaultFonts =
        {
          monospace = cfg.defaultFonts.monospace.names;
          serif     = cfg.defaultFonts.serif.names;
          sansSerif = cfg.defaultFonts.sansSerif.names;
          emoji     = cfg.defaultFonts.emoji.names;
        };
      };
    };

    # {{{ Home-Manager
    home-manager.users.${config.custom.users.mainUser} =
    {
      gtk.font =
      {
        name = builtins.head cfg.defaultFonts.sansSerif.names;
        size = cfg.size;
      };
    };
    # }}}
  };
}
