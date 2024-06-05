## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Flatpak config
##

{ config, lib, ... }:

let
  cfg = config.custom.services.flatpak;
in
{
  options.custom.services.flatpak =
  {
    enable   = lib.mkEnableOption "enables Flatpak";
    packages = lib.mkOption
    {
      type        = with lib.types; listOf (coercedTo str (appId: { inherit appId; }) (submodule packageOptions));
      default     = [ ];
      description = "declares a list of applications to install";
    };
  };

  config = lib.mkIf cfg.enable
  {
    services.flatpak =
    {
      enable   = lib.mkDefault true;
      packages = lib.mkDefault cfg.packages;

      update.auto =
      {
        enable     = true;
        onCalendar = "daily";
      };

      overrides.global =
      {
        Context.filesystems =
        [
          "$HOME/.local/share/icons:ro"
          "$HOME/.local/share/themes:ro"
          "$HOME/.local/share/fonts:ro"
          "/nix/store:ro"
        ];

        Environment =
        {
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      };
    };
  };
}
