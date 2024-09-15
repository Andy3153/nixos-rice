# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
{
  description = "Flake-based empty development environment";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
  in
  {
    devShells = forEachSupportedSystem ({ pkgs }:
    {
      default = pkgs.mkShell
      {
        # Packages the devenv will provide
        packages = with pkgs;
        [

        ];

        # Environment variables for the devenv
        env =
        {

        };

        # Commands to run at the activation of the devenv
        shellHook =
        ''

        '';
      };
    });
  };
}
