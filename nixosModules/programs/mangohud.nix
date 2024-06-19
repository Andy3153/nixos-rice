## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## MangoHud config
##

{ config, lib, pkgs, ... }:

let
  cfg = config.custom.programs.mangohud;
in
{
  options.custom.programs.mangohud.enable = lib.mkEnableOption "enables MangoHud";

  config = lib.mkIf cfg.enable
  {
    environment.systemPackages = with pkgs; [ mangohud ];

  # {{{ Home-Manager
  home-manager.users.${config.custom.users.mainUser} =
  {
    home.file.".config/MangoHud/MangoHud.conf".source =
      /home/andy3153/src/hyprland/hyprland-rice/dotconfig/MangoHud/MangoHud.conf;
  };
  # }}}
  };
}
