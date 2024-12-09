## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Gaming config
##

{ config, lib, pkgs, ... }:

let
  cfg     = config.custom.gui.gaming;
  quantum = 64;
  rate    = 48000;
  qr      = "${toString quantum}/${toString rate}";
in
{
  options.custom.gui.gaming =
  {
    enable               = lib.mkEnableOption "enables various gaming things";
    optimizations.enable = lib.mkEnableOption "enables gaming optimizations";
  };

  config = lib.mkMerge
  [
    # {{{ Gaming sane defaults
    (lib.mkIf cfg.enable
    {
      custom =
      {
        # {{{ Extra packages
        extraPackages = with pkgs;
        [
          depotdownloader                     # for-steam
          extest                              # for-steam for-controllers
          wineWowPackages.staging             # wine
          protonup-qt                         # for-steam for-wine
          protontricks                        # for-steam for-wine

          bottles                             # for-wine
          lutris                              # for-wine

          prismlauncher                       # games
          xonotic                             # games

          mesa-demos                          # glxgears
        ];
        # }}}

        # Enable Xbox controller drivers
        hardware.controllers.xbox.enable = true;

        # Enable renicing daemon
        #services.ananicy.enable          = true;

        # {{{ Programs
        programs =
        {
          steam.enable    = true;
          gamemode.enable = true;

          mangohud =
          {
            enable              = true;
            enableCustomConfigs = true;
          };
        };
        # }}}
      };
    })
    # }}}

    # {{{ Gaming optimizations
    (lib.mkIf cfg.optimizations.enable # stolen from https://github.com/fufexan/nix-gaming
    {
      # {{{ PipeWire low latency
      services.pipewire = {
        # write extra config
        extraConfig.pipewire = {
          "99-lowlatency" = {
            context = {
              properties.default.clock.min-quantum = quantum;
              modules = [
                {
                  name = "libpipewire-module-rtkit";
                  flags = ["ifexists" "nofail"];
                  args = {
                    nice.level = -15;
                    rt = {
                      prio = 88;
                      time.soft = 200000;
                      time.hard = 200000;
                    };
                  };
                }
                {
                  name = "libpipewire-module-protocol-pulse";
                  args = {
                    server.address = ["unix:native"];
                    pulse.min = {
                      req = qr;
                      quantum = qr;
                      frag = qr;
                    };
                  };
                }
              ];

              stream.properties = {
                node.latency = qr;
                resample.quality = 1;
              };
            };
          };
        };

        wireplumber = {
          configPackages = let
            # generate "matches" section of the rules
            matches = lib.generators.toLua {
              multiline = false; # looks better while inline
              indent = false;
            } [[["node.name" "matches" "alsa_output.*"]]]; # nested lists are to produce `{{{ }}}` in the output

            # generate "apply_properties" section of the rules
            apply_properties = lib.generators.toLua {} {
              "audio.format" = "S32LE";
              "audio.rate" = rate * 2;
              "api.alsa.period-size" = 2;
            };
          in [
            (pkgs.writeTextDir "share/lowlatency.lua.d/99-alsa-lowlatency.lua" ''
              -- Generated by nix-gaming
              alsa_monitor.rules = {
                {
                  matches = ${matches};
                  apply_properties = ${apply_properties};
                }
              }
            '')
          ];
        };
      };
      # }}}

      # {{{ Optimizations from SteamOS
      # last cheched with https://steamdeck-packages.steamos.cloud/archlinux-mirror/jupiter-main/os/x86_64/steamos-customizations-jupiter-20240219.1-2-any.pkg.tar.zst
      boot.kernel.sysctl = {
        # 20-shed.conf
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        # 20-net-timeout.conf
        # This is required due to some games being unable to reuse their TCP ports
        # if they're killed and restarted quickly - the default timeout is too large.
        "net.ipv4.tcp_fin_timeout" = 5;
        # 30-vm.conf
        # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
        # see comment in include/linux/mm.h in the kernel tree.
        "vm.max_map_count" = 2147483642;
      };
      # }}}
    })
    # }}}
  ];
}
