## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## System keys config
##
## https://www.freedesktop.org/software/systemd/man/latest/logind.conf.html
##

{ config, lib, pkgs, ... }:

# {{{ Variables
let
  cfg = config.custom.hardware.systemKeys;

  powerKeyType = lib.types.enum
  [
    "factory-reset"          "halt"     "hibernate"
    "hybrid-sleep"           "ignore"   "kexec"
    "lock"                   "poweroff" "reboot"
    "secure-attention-key"   "sleep"    "suspend"
    "suspend-then-hibernate"
  ];

  initrdPowerKeyType = lib.types.enum
  [
    "ignore" "poweroff" "reboot" "suspend"
  ];
in
# }}}
{
  # {{{ Options
  options.custom.hardware.systemKeys =
  {
    # {{{ Initrd
    initrd =
    {
      lid = lib.mkOption
      {
        type        = initrdPowerKeyType;
        default     = "suspend";
        example     = "ignore";
        description = "how the lid switch should be handled while inside initial ramdisk";
      };

      power = lib.mkOption
      {
        type        = initrdPowerKeyType;
        default     = "poweroff";
        example     = "ignore";
        description = "how the power key should be handled while inside initial ramdisk";
      };
    };
    # }}}

    # {{{ Normal
    lid = lib.mkOption
    {
      type        = powerKeyType;
      default     = "suspend-then-hibernate";
      example     = "ignore";
      description = "how the lid switch should be handled";
    };

    power = lib.mkOption
    {
      type        = powerKeyType;
      default     = "poweroff";
      example     = "ignore";
      description = "how the power key should be handled";
    };

    powerLongPress = lib.mkOption
    {
      type        = powerKeyType;
      default     = "ignore";
      example     = "suspend-then-hibernate";
      description = "how the power key should be handled when held pressed";
    };
    # }}}
  };
  # }}}

  # {{{ Config
  config =
  {
    # {{{ Initrd
    boot.initrd = lib.mkIf ((cfg.initrd.lid != "ignore") || (cfg.initrd.power != "ignore"))
    {
      kernelModules = [ "button" "evdev" ];

      systemd =
      {
        extraBin.acpid = "${lib.getExe pkgs.acpid}";

        # {{{ Acpid rules
        contents =
        # {{{ Variables
        let
          cmd = button:
            if (button == "poweroff" || button == "reboot")
            then "shutdown --no-wall --${button} now"
            else
            if button == "suspend"
            then "sh -c 'echo mem > /sys/power/state'"
            else "";
        in
        # }}}
        {
          # {{{ Action on lid close
          "/etc/acpi/events/lid".text = lib.mkIf (cfg.initrd.lid != "ignore")
          ''
          event=button/lid LID close
          action=${cmd cfg.initrd.lid}
          '';
          # }}}

          # {{{ Action on power button
          "/etc/acpi/events/power".text = lib.mkIf (cfg.initrd.power != "ignore")
          ''
          event=button/power.*
          action=${cmd cfg.initrd.power}
          '';
          # }}}
        };
        # }}}

        # {{{ Acpid systemd service
        services.initrdSystemKeys =
        {
          description = "Manage system keys in the initial ramdisk using acpid";
          wantedBy    = [ "initrd.target" ];
          after       = [ "systemd-modules-load.service" ];

          unitConfig.DefaultDependencies = false;

          serviceConfig =
          {
            ExecStartPre =
            [
              "${lib.getExe' pkgs.coreutils "mkdir"} -p /var"
              "${lib.getExe' pkgs.coreutils "ln"} -sfn /run /var/run"
            ];

            ExecStart = "${lib.getExe pkgs.acpid} --foreground --netlink --logevents";
          };
        };
        # }}}
      };
    };
    # }}}

    # {{{ Normal
    services.logind.settings.Login =
    {
      HandleLidSwitch              = cfg.lid;
      HandleLidSwitchDocked        = cfg.lid;
      HandleLidSwitchExternalPower = cfg.lid;

      HandlePowerKey          = cfg.power;
      HandlePowerKeyLongPress = cfg.powerLongPress;
    };
    # }}}
  };
  # }}}
}
