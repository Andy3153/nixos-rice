## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Floorp (NixPak)
##

{ config, lib, pkgs, nixpakCustom, ... }:

let
  cfg = config.custom.programs.nixpak.floorp;

  pkg-script = pkg.config.script;
  pkg-env    = pkg.config.env;

  pkg = nixpakCustom.mkNixPak
  {
    config = { config, sloth, ... }:
    {
      imports = [ nixpakCustom.opts ];

      app.package = pkgs.floorp-bin;

      custom =
      {
        gpu.enable     = true;
        gui.enable     = true;
        network.enable = true;
        sound.enable   = true;
      };
    };
  };
in
{
  options.custom.programs.nixpak.floorp.enable = lib.mkEnableOption "enables Floorp (NixPak)";
  config.custom.extraPackages = lib.mkIf cfg.enable [ pkg-env ];
}
