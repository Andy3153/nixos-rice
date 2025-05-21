<!-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}: -->
# nixos-rice
This repository contains a Nix flake with various flake outputs:

<!-- {{{ NixOS Configurations -->
## NixOS Configurations
These are configurations for all the hardware I own:

<!-- {{{ sparkle -->
- `sparkle`
-- my main machine. I have lots of configurations for [Hyprland](https://github.com/Andy3153/hyprland-rice), [Zsh](https://github.com/Andy3153/andy3153-zshrc), [Neovim](https://github.com/Andy3153/andy3153-init.lua), gaming, virtual machines, Secure Boot, RGB control and many others. Also do check out the [NixOS Hardware](https://github.com/NixOS/nixos-hardware/tree/master/asus/fx506hm) entry on this laptop.
<!-- }}} -->

<!-- {{{ helix -->
- `helix`
-- my new server. It's meant to replace `ember`. The config for it is basically a comfy bootloader for Docker.
<!-- }}} -->

<!-- {{{ ember -->
- `ember`
-- my old server. It has been replaced by `helix`. The config for it is basically a comfy bootloader for Docker. It's full of Docker containers. You can see various repos on my profile with Docker Compose files and custom images. Be sure they all ran at least once on this server.
<!-- }}} -->

<!-- {{{ Usage -->
### Usage
You can use these configurations by pointing to this flake when rebuilding, for example:

```console
$ git clone https://github.com/Andy3153/nixos-rice
$ cd nixos-rice/
$ nixos-rebuild switch --impure --use-remote-sudo --flake .#sparkle
```
<!-- }}} -->
<!-- }}} -->

<!-- {{{ NixOS Modules -->
## NixOS Modules
<!-- {{{ default -->
- `default`

All NixOS configurations specified previously make use of these modules. I wrote them wanting to make individual NixOS configuration files for separate hosts smaller in size and easier to write.

They mostly follow the structure the NixOS modules they are based on follow, but I deviated where I thought I could make things better/shorter, or where I added completely custom options.

This entire module is very opinionated, since I made it for myself to fit my use cases. Firstly, the modules do things just by being imported, which is bad practice, and secondly, some options include accessing files not inside the flake, and so, the configurations written with these modules can become impure. All my NixOS configurations are impure, because I access non-Nix configuration files I didn't want to convert to Nix modules. And so, they might not fit your use case at all, but I believe they'll come in handy to someone else as examples to make your own custom modules like I did too.

As it's mostly for myself, I didn't write/auto-generate any documentation, but every single option has a `description` filled with an explanation, and the names of the options are as self-explanatory as I could think to make them.
<!-- }}} -->

<!-- {{{ Usage -->
### Usage
You can use these modules by adding this flake into your flake's inputs, and then adding its path to `outputs.nixosConfigurations.<name>.modules`, for example:

```nix
{
  inputs =
  {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-rice.url = "github:Andy3153/nixos-rice";
  };

  outputs = inputs@
  {
    self,
    nixpkgs,
    nixos-rice,
    ...
  }: rec
  {
    nixosConfigurations.<name> = nixpkgs.lib.nixosSystem
    {
      modules =
      [
        nixos-rice.nixosModules.default

        ./path/to/your/configuration.nix
      ];
    };
  };
}
```
<!-- }}} -->
<!-- }}} -->

<!-- {{{ Images -->
### Images
<!-- {{{ ember -->
- `ember`
-- generates an image file with everything in `ember`'s NixOS configuration that can be flashed to a flash drive or an SD card that a Raspberry Pi can boot from.
<!-- }}} -->

<!-- {{{ Usage -->
### Usage
You can generate these images by using `nix build` on the flake, for example:

```console
$ git clone https://github.com/Andy3153/nixos-rice
$ cd nixos-rice/
$ nix build .#images.ember
```
<!-- }}} -->
<!-- }}} -->

<!-- {{{ Templates -->
### Templates
<!-- {{{ devenv-empty -->
- `devenv-empty`
-- written to be more of a template for future templates.
<!-- }}} -->

<!-- {{{ devenv-python -->
- `devenv-python`
-- a template for a Python development environment.
<!-- }}} -->

<!-- {{{ Usage -->
### Usage
You can use these templates by using `nix init`, for example:

```console
nix flake init --template github:Andy3153/nixos-rice#devenv-py
```
<!-- }}} -->
<!-- }}} -->
