# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
{
  description = "Flake-based Python development environment";
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
        packages = with pkgs;
        [
          (python3.withPackages(python-pkgs: with python-pkgs;
          [
            # For creating and uploading packages to PyPi
            build
            twine

            # Insert others here...
            #requests
          ]))
        ];
      };
    });
  };
}
