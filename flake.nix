## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixOS flake by Andy3153
## created   02/12/23 ~ 15:17:52
## rewrote   15/03/24 ~ 16:56:09
##

{
  description = "Andy3153's NixOS flake";

  # {{{ Inputs
  inputs = rec
  {
    # {{{ NixPkgs
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs_stable.url   = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs              = nixpkgs_unstable;
    # }}}

    # {{{ NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # }}}

    # {{{ Lanzaboote
    lanzaboote_unstable =
    {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    lanzaboote_stable =
    {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };

    lanzaboote =
    {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ Nix Index Database
    nix-index-database_unstable =
    {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    nix-index-database_stable =
    {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };

    nix-index-database =
    {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ Determinate Systems' Nix
    detsys-nix_unstable =
    {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    detsys-nix_stable =
    {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };

    detsys-nix =
    {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ Nix-Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
    # }}}

    # {{{ Home-Manager
    home-manager_unstable =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    home-manager_stable =
    {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };

    home-manager =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ NixOS-VFIO
    nixos-vfio_unstable =
    {
      url = "github:j-brn/nixos-vfio";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    nixos-vfio_stable =
    {
      url = "github:j-brn/nixos-vfio";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };

    nixos-vfio =
    {
      url = "github:j-brn/nixos-vfio";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ Disko
    disko_unstable =
    {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    disko_stable =
    {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };

    disko =
    {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ Spicetify
    spicetify.url = "github:Gerg-L/spicetify-nix";
    # }}}
  };
  # }}}

  # {{{ Outputs
  outputs = inputs@
  # {{{ Inputs
  {
    self,

    nixpkgs_unstable,
    nixpkgs_stable,
    nixpkgs,

    nixos-hardware,

    lanzaboote_unstable,
    lanzaboote_stable,
    lanzaboote,

    nix-index-database_unstable,
    nix-index-database_stable,
    nix-index-database,

    detsys-nix_stable,
    detsys-nix_unstable,
    detsys-nix,

    nix-flatpak,

    home-manager_unstable,
    home-manager_stable,
    home-manager,

    nixos-vfio_unstable,
    nixos-vfio_stable,
    nixos-vfio,

    disko_unstable,
    disko_stable,
    disko,

    spicetify,

    ...
  }:
  # }}}
  # {{{ Variables
  let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forEachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f
    {
      pkgs    = import nixpkgs { inherit system; };
      my-pkgs = self.outputs.packages.${system};
    });
  in
  # }}}
  {
    # {{{ NixOS configurations
    nixosConfigurations =
    {
      # {{{ sparkle | ASUS TUF F15 FX506HM
      sparkle = nixpkgs.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        modules =
        [
          { networking.hostName = "sparkle"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs_unstable { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs_stable   { config = config.nixpkgs.config; };
                my-pkgs       = self.outputs.packages.x86_64-linux;
              };
            }
          )
          # }}}

          nixos-hardware.nixosModules.asus-fx506hm
          lanzaboote.nixosModules.lanzaboote
          nix-index-database.nixosModules.default
          detsys-nix.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          (import "${nixos-vfio}/modules/kvmfr" { std = nixos-vfio.inputs.nix-std.lib; })
          (import "${nixos-vfio}/modules/vfio")
          disko.nixosModules.disko
          spicetify.nixosModules.spicetify

          ./hosts/sparkle
        ];
      };
      # }}}

      # {{{ fidget | Lenovo ThinkPad X280
      fidget = nixpkgs.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        modules =
        [
          { networking.hostName = "fidget"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs_unstable { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs_stable   { config = config.nixpkgs.config; };
                my-pkgs       = self.outputs.packages.x86_64-linux;
              };
            }
          )
          # }}}

          # {{{ Dummy modules so I don't have to import inputs I don't need
          ({ options, lib, ... }:
          {
            options =
            {
              virtualisation.kvmfr = lib.mkOption { };
              virtualisation.vfio  = lib.mkOption { };
            };
          })
          # }}}

          nixos-hardware.nixosModules.lenovo-thinkpad-x280
          lanzaboote.nixosModules.lanzaboote
          nix-index-database.nixosModules.default
          detsys-nix.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          #nixos-vfio.nixosModules.default
          disko.nixosModules.disko
          spicetify.nixosModules.spicetify

          ./hosts/fidget
        ];
      };
      # }}}

      # {{{ helix | Lenovo Ideapad 320
      helix = nixpkgs_stable.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        modules =
        [
          { networking.hostName = "helix"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs_unstable { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs_stable   { config = config.nixpkgs.config; };
              };
            }
          )
          # }}}

          # {{{ Dummy modules so I don't have to import inputs I don't need
          ({ options, lib, ... }:
          {
            options =
            {
              programs.spicetify         = lib.mkOption { };
              services.flatpak.overrides = lib.mkOption { };
              services.flatpak.packages  = lib.mkOption { };
              services.flatpak.update    = lib.mkOption { };
              virtualisation.kvmfr       = lib.mkOption { };
              virtualisation.vfio        = lib.mkOption { };
            };
          })
          # }}}

          lanzaboote_stable.nixosModules.lanzaboote
          nix-index-database_stable.nixosModules.default
          detsys-nix_unstable.nixosModules.default
          home-manager_stable.nixosModules.home-manager
          disko_stable.nixosModules.disko

          ./hosts/helix
        ];
      };
      # }}}
    };
    # }}}

    # {{{ NixOS modules
    nixosModules = rec
    {
      default    = nixos-rice;
      nixos-rice = ./modules;
    };
    # }}}

    # {{{ Packages
    packages = forEachSystem ({ pkgs, my-pkgs }:
    {
      batnotifsd               = pkgs.callPackage ./pkgs/batnotifsd.nix               { };
      plymouth-spinnerv2-theme = pkgs.callPackage ./pkgs/plymouth-spinnerv2-theme.nix { };
      weather4bar              = pkgs.callPackage ./pkgs/weather4bar.nix              { };
    });
    # }}}

    # {{{ Templates
    templates = rec
    {
      default = devenv-empty;

      # {{{ Development environments
      # {{{ Empty
      devenv-empty =
      {
        path = ./templates/devenv/empty;
        description = "Empty development environment";
      };
      # }}}

      # {{{ Python
      devenv-python =
      {
        path = ./templates/devenv/python;
        description = "Python development environment";
      };
      devenv-py = devenv-python;
      # }}}
      # }}}
    };
    # }}}
  };
  # }}}
}
