## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Btop config
##

{ config, lib, pkgs, ... }:

# {{{ Variables
let
  cfg = config.custom.programs.btop;

  mainUser   = config.custom.users.mainUser;
  HM         = config.home-manager.users.${mainUser};
  configHome = HM.xdg.configHome;

  # {{{ Package
  btopPkg = (pkgs.btop.override
  {
    cudaSupport   = cfg.acceleration.cuda;
    rocmSupport   = false;
  });
  # }}}

  # {{{ Theme package
  themePkg = (pkgs.catppuccin.override
  {
    themeList = [ "btop" ];
    accent    = "blue";
    variant   = "mocha";
  });
  # }}}
in
# }}}
{
  # {{{ Options
  options.custom.programs.btop =
  {
    enable              = lib.mkEnableOption "enables Btop";
    enableCustomConfigs = lib.mkEnableOption "enable my custom configs";

    # {{{ Acceleration
    acceleration.cuda = lib.mkOption
    {
      type        = lib.types.bool;
      default     = config.custom.hardware.nvidia.enable;
      example     = true;
      description = "enable CUDA acceleration";
    };
    # }}}

    # {{{ Theme
    theme =
    {
      name = lib.mkOption
      {
        type        = lib.types.str;
        default     = "catppuccin_mocha";
        description = "theme package";
      };

      package = lib.mkOption
      {
        type        = lib.types.package;
        default     = themePkg;
        description = "theme package";
      };
    };
    # }}}
  };
  # }}}

  # {{{ Config
  config = lib.mkIf cfg.enable
  {
    # {{{ Home-Manager
    home-manager.users.${mainUser} =
    {
      # {{{ Btop
      programs.btop =
      {
        enable  = true;
        package = btopPkg;
        themes  = { "${cfg.theme.name}" = builtins.readFile "${cfg.theme.package}/btop/${cfg.theme.name}.theme"; };

        # {{{ Settings
        settings =
        let
          btrfsSubvols      = config.custom.filesystems.disk.main.partitions.main.subvolumes;
          rootPath          = btrfsSubvols."/root".mountpoint;
          btrfsSubvolsInfo  = builtins.attrValues btrfsSubvols;
          btrfsSubvolsPaths = builtins.map (x: x.mountpoint) btrfsSubvolsInfo;
          disksFilterList   = lib.lists.remove rootPath btrfsSubvolsPaths;
          disks_filter      = "exclude=" + lib.concatStringsSep " " disksFilterList;
        in
        {
          clock_format        = "%a %d %b | %H:%M:%S";
          color_theme         = cfg.theme.name;
          disks_filter        = disks_filter;
          io_graph_combined   = true;
          save_config_on_exit = true;
          swap_disk           = false;
          theme_background    = false;
          update_ms           = 500;
          vim_keys            = true;
        };
        # }}}
      };
      # }}}
    };
    # }}}
  };
  # }}}
}
