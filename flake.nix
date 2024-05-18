## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixOS flake by Andy3153
## created   02/12/23 ~ 15:17:52
## rewrote   15/03/24 ~ 16:56:09
##

{
  description = "Andy3153's NixOS flake";

  # {{{ Inputs
  inputs =
  {
    # NixPkgs Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home-Manager
    home-manager =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";

    # programs.sqlite for Nix Flakes
    flake-programs-sqlite =
    {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # }}}

  # {{{ Outputs
  outputs = { self, nixpkgs, home-manager, nix-flatpak, flake-programs-sqlite, ... }@inputs:
  # {{{ Variables
  let
    system = "x86_64-linux";

    # NixPkgs Unstable
    pkgs = import nixpkgs
    {
      inherit system;
      config.allowUnfree = true;
    };
  in
  # }}}
  {
    nixosConfigurations =
    {
      # {{{ sparkle
      sparkle = nixpkgs.lib.nixosSystem
      {
        specialArgs = { inherit inputs system pkgs; };

        modules =
        [
          flake-programs-sqlite.nixosModules.programs-sqlite
          nix-flatpak.nixosModules.nix-flatpak

          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager =
            {
              useGlobalPkgs   = true;
              useUserPackages = true;
              users.andy3153  = import ./home.nix;
            };
          }
        ];
      };
      # }}}
    };
  };
  # }}}
}
