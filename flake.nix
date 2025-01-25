## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixOS flake by Andy3153
## created   02/12/23 ~ 15:17:52
## rewrote   15/03/24 ~ 16:56:09
##

{
  description = "Andy3153's Nix flake";

  # {{{ Inputs
  inputs =
  {
    # {{{ NixPkgs
    # NixPkgs Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixPkgs 24.11
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # NixPkgs for TiLP
    nixpkgs-tilp.url = "github:nixos/nixpkgs/0be46d0515c69cddaea4c4e01b62e2a318c379b4";

    # NixPkgs (my fork for when I'm working on something)
    #nixpkgs-andy3153.url = "github:Andy3153/nixpkgs/hunspell-ro_RO";
    #nixpkgs-andy3153.url = "git+file:////home/andy3153/src/nixos/nixpkgs/?ref=hunspell-ro_RO";
    # }}}

    # {{{ My Nix packages
    my-nixpkgs =
    {
      url = "github:Andy3153/my-nixpkgs";
      #url = "git+file:///home/andy3153/src/nixos/my-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ NixOS Hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    #nixos-hardware.url = "github:Andy3153/nixos-hardware/asus-fx506hm_nvidia-open";
    #nixos-hardware.url = "git+file:///home/andy3153/src/nixos/nixos-hardware/?ref=asus-fx506hm_nvidia-open";
    # }}}

    # {{{ Lanzaboote
    lanzaboote =
    {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ programs.sqlite for Nix Flakes
    flake-programs-sqlite =
    {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ in-nix (add envvar when in `nix shell`)
    in-nix =
    {
      url = "github:viperML/in-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}

    # {{{ Nix-Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/latest";
    # }}}

    # {{{ Home-Manager
    home-manager =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-stable =
    {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    # }}}

    # {{{ Jovian NixOS (Steam Deck UI)
    jovian =
    {
      #url = "github:Jovian-Experiments/Jovian-NixOS";
      url = "github:Andy3153/Jovian-NixOS/guard-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # }}}
  };
  # }}}

  # {{{ Outputs
  outputs = inputs@
  # {{{ Inputs
  {
    self,
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-tilp,
    #nixpkgs-andy3153,
    my-nixpkgs,
    nixos-hardware,
    lanzaboote,
    flake-programs-sqlite,
    in-nix,
    nix-flatpak,
    home-manager,
    home-manager-stable,
    jovian,
    ...
  }: rec
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
                pkgs-unstable = import nixpkgs        { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs-stable { config = config.nixpkgs.config; };
                pkgs-tilp     = import nixpkgs-tilp   { config = config.nixpkgs.config; };
                my-pkgs       = my-nixpkgs.packages.x86_64-linux;
              };
            }
          )
          # }}}

          nixos-hardware.nixosModules.asus-fx506hm
          lanzaboote.nixosModules.lanzaboote
          flake-programs-sqlite.nixosModules.programs-sqlite
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          jovian.nixosModules.jovian

          ./hosts/sparkle
        ];
      };
      # }}}

      # {{{ ember | Raspberry Pi 4
      ember = nixpkgs-stable.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        modules =
        [
          { networking.hostName = "ember"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs        { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs-stable { config = config.nixpkgs.config; };
              };
            }
          )
          # }}}

          # {{{ Dummy modules so I don't have to import inputs I don't need
          (
            { options, lib, ... }:
            let
              dummyOpt = lib.mkOption { type = lib.types.anything; default = null; };
            in
            {
              options =
              {
                boot.lanzaboote            = dummyOpt;
                jovian                     = dummyOpt;
                services.flatpak.overrides = dummyOpt;
                services.flatpak.packages  = dummyOpt;
                services.flatpak.update    = dummyOpt;
              };
            }
          )
          # }}}

          "${nixpkgs-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          nixos-hardware.nixosModules.raspberry-pi-4
          flake-programs-sqlite.nixosModules.programs-sqlite
          home-manager-stable.nixosModules.home-manager

          ./hosts/ember
        ];
      };

      # {{{ Configuration for `ember` host when made into an SD card image
      ember-image = self.nixosConfigurations.ember.extendModules
      {
        modules = [ { disabledModules =
        [
          # These apply to the already-installed system and its custom
          # partitioning, we need to disable this for the image creation
          ./hosts/ember/hardware-configuration.nix
        ]; } ];
      };
      # }}}
      # }}}

      # {{{ naegl | Lenovo Ideapad 320
      naegl = nixpkgs-stable.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        modules =
        [
          { networking.hostName = "naegl"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs        { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs-stable { config = config.nixpkgs.config; };
              };
            }
          )
          # }}}

          # {{{ Dummy modules so I don't have to import inputs I don't need
          (
            { options, lib, ... }:
            let
              dummyOpt = lib.mkOption { type = lib.types.anything; default = null; };
            in
            {
              options =
              {
                jovian                     = dummyOpt;
                services.flatpak.overrides = dummyOpt;
                services.flatpak.packages  = dummyOpt;
                services.flatpak.update    = dummyOpt;
              };
            }
          )
          # }}}

          nixos-hardware.nixosModules.raspberry-pi-4
          lanzaboote.nixosModules.lanzaboote
          flake-programs-sqlite.nixosModules.programs-sqlite
          home-manager-stable.nixosModules.home-manager

          ./hosts/naegl
        ];
      };
      # }}}

      # {{{ livecd | Live CD
      livecd = nixpkgs.lib.nixosSystem
      {
        specialArgs = { inherit inputs; }; # access inputs in config
        system      = "x86_64-linux";

        modules =
        [
          { networking.hostName = "nixos-live"; } # Hostname

          # {{{ Add flake inputs to configuration
          (
            { config, ... }:
            {
              _module.args =
              {
                pkgs-unstable = import nixpkgs        { config = config.nixpkgs.config; };
                pkgs-stable   = import nixpkgs-stable { config = config.nixpkgs.config; };
                my-pkgs       = my-nixpkgs.packages.x86_64-linux;
              };
            }
          )
          # }}}

          # {{{ Dummy modules so I don't have to import inputs I don't need
          (
            { options, lib, ... }:
            let
              dummyOpt = lib.mkOption { type = lib.types.anything; default = null; };
            in
            {
              options =
              {
                boot.lanzaboote = dummyOpt;
                jovian          = dummyOpt;
              };
            }
          )
          # }}}

          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          flake-programs-sqlite.nixosModules.programs-sqlite
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager

          ./hosts/livecd
        ];
      };
      # }}}
    };
    # }}}

    # {{{ Images
    images =
    {
      ember = nixosConfigurations.ember-image.config.system.build.sdImage;
    };
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
