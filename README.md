<!-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}: -->
# nixos-rice
These are all the NixOS configurations and custom modules that I use on a daily basis.

## A warning
Feel free to try and use this, but at this point it isn't really meant for other people to use for reasons like the fact that I directly point to impure files on my filesystem for crucial program configuration files that you'd manually have to git clone into your filesystem. You can still use my stuff as examples though.

## My custom modules
I wrote custom modules for everything my system needs to do, I barely need to use normal Nix configuration options. Feel free to check them out.

## Flake outputs
### NixOS configurations
#### `sparkle` | ASUS TUF F15 FX506HM
This is my main machine. I have lots of configs for [Hyprland](https://github.com/Andy3153/hyprland-rice), [Zsh](https://github.com/Andy3153/andy3153-zshrc), [Neovim](https://github.com/Andy3153/andy3153-init.lua), gaming, virtual machines, Secure Boot, RGB control and many others. Also do check out the [NixOS Hardware](https://github.com/NixOS/nixos-hardware/tree/master/asus/fx506hm) entry on this laptop.

<!--
#### `naegl` | Lenovo Ideapad 320
This is my new server. It's meant to replace `ember`. The config for it is basically a comfy bootloader for Docker. It's full of Docker containers.

#### `ember` | Raspberry Pi 4
This is my old server. It has been replaced by `naegl`. The config for it is basically a comfy bootloader for Docker. It's full of Docker containers. You can see various repos on my profile with Docker Compose files and custom images. Be sure they all ran at least once on this server.
-->

#### `ember` | Raspberry Pi 4
This is my server. The config for it is basically a comfy bootloader for Docker. It's full of Docker containers. You can see various repos on my profile with Docker Compose files and custom images. Be sure they all ran at least once on this server.

### Images
#### `ember`
This generates a Raspberry Pi SD card image with everything in `ember`'s NixOS configuration on it. I usually use it to boot from a flash drive/SD card, partition my external hard drive the way I want, and then run `nixos-install` from the flash drive/SD card on the external hard drive. It works. Surprisingly well.

### Templates
- Empty development environment
- Python development environment
