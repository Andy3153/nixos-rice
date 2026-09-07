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
  themePkg = (pkgs.btop.override
  {
    cudaSupport   = cfg.acceleration.cuda;
    rocmSupport   = false;
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
    theme.package = lib.mkOption
    {
      type        = lib.types.package;
      default     = themePkg;
      description = "theme package";
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

        # {{{ Settings
        settings =
        {
          clock_format        = "%a %d %b | %H:%M:%S";
          io_graph_combined   = true;
          save_config_on_exit = true;
          swap_disk           = false;
          theme_background    = false;
          update_ms           = 500;
          vim_keys            = true;


          #color_theme = "";
          #disks_filter = "exclude=/.btrfs-root /.snapshots /.snapshots.externalhdd /.swap /home /home/andy3153/games /home/andy3153/downs/torrents /nix /nix/store /var/cache /var/log /var/tmp /var/lib/libvirt/images"
        };
        # }}}
      };
      # }}}
    };
    # }}}
  };
  # }}}
}
