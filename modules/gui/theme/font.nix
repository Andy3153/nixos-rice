## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Font config
##

{ config, lib, ... }:

# {{{ Variables
let
  cfg      = config.custom.gui.theme.font;
  mainUser = config.custom.users.mainUser;
in
# }}}
{
  # {{{ Options
  options.custom.gui.theme.font = lib.mkOption
  {
    type = lib.types.nullOr (lib.types.submodule
    {
      options =
      {
        # {{{ Default fonts
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
        # }}}

        extraFontPackages = lib.mkOption
        {
          type        = lib.types.listOf lib.types.path;
          default     = [];
          description = "list of extra font packages";
        };

        # {{{ Size
        size =
        {
          fixed = lib.mkOption
          {
            type        = lib.types.int;
            default     = 12;
            example     = 15;
            description = "font size for fixed width fonts";
          };

          general = lib.mkOption
          {
            type        = lib.types.int;
            default     = 11;
            example     = 12;
            description = "font size for general fonts";
          };
        };
        # }}}

        # {{{ Weight
        weight =
        {
          fixed = lib.mkOption
          {
            type        = lib.types.int;
            default     = 400;
            example     = 500;
            description = "font weight for fixed width fonts";
          };

          general = lib.mkOption
          {
            type        = lib.types.int;
            default     = 400;
            example     = 500;
            description = "font weight for general fonts";
          };
        };
        # }}}
      };
    });

    default     = null;
    description = "font configuration";
  };
  # }}}

  # {{{ Config
  config = lib.mkIf (cfg != null)
  {
    fonts =
    {
      enableDefaultPackages = true;
      fontDir.enable        = true;

      # {{{ Packages
      packages =
        cfg.defaultFonts.monospace.packages ++
        cfg.defaultFonts.serif.packages     ++
        cfg.defaultFonts.sansSerif.packages ++
        cfg.defaultFonts.emoji.packages     ++
        cfg.extraFontPackages;
      # }}}

      # {{{ Fontconfig
      fontconfig =
      {
        enable = true;

        defaultFonts =
        {
          monospace = cfg.defaultFonts.monospace.names;
          serif     = cfg.defaultFonts.serif.names;
          sansSerif = cfg.defaultFonts.sansSerif.names;
          emoji     = cfg.defaultFonts.emoji.names;
        };
      };
      # }}}
    };

    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      fonts.fontconfig.enable = true;

      gtk.font =
      {
        name = builtins.head cfg.defaultFonts.sansSerif.names;
        size = cfg.size.general;
      };
    };
    # }}}
  };
  # }}}
}
