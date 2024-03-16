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
    # NixPkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # switch to unstable

    # Home-Manager
    home-manager =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";
  };
  # }}}

  # {{{ Outputs
  outputs = { self, nixpkgs, nix-flatpak, ... }@inputs:
  # {{{ Variables
  let
    system= "x86_64-linux";
    pkgs = import nixpkgs
    {
      inherit system;
      config = { allowUnfree = true; };
    };
  in
  # }}}
  {
    nixosConfigurations =
    {
      # {{{ andy3153-nixos NixOS configuration
      andy3153-nixos = nixpkgs.lib.nixosSystem
      {
        specialArgs = { inherit inputs system; };

        modules =
        [
          nix-flatpak.nixosModules.nix-flatpak
          ./configuration.nix
        ];
      };
      # }}}
    };
  };
  # }}}
}
