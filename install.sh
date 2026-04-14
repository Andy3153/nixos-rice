#!/usr/bin/env bash
set -euxo pipefail

NIXOSRICE_HOSTNAME="${1}"

cd ~
git clone https://github.com/Andy3153/nixos-rice

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake "/home/nixos/nixos-rice#${NIXOSRICE_HOSTNAME}"

sudo swapon /mnt/.swap/swapfile

cd /mnt/home/andy3153
sudo mkdir src
sudo chown -R 1000:1000 src
cd src
mkdir hyprland nix nvim sh

git clone --recursive https://github.com/Andy3153/hyprland-rice       hyprland/hyprland-rice
git clone             https://github.com/Andy3153/andy3153-init.lua   nvim/andy3153-init.lua
cp -r                 ~/nixos-rice                                    nix
git clone             https://github.com/Andy3153/andy3153-zshrc      sh/andy3153-zshrc
git clone             https://github.com/Andy3153/other-shell-scripts sh/other-shell-scripts

sudo chown -R 3153:3153 /mnt/home/andy3153

sudo nixos-install --flake "/home/nixos/nixos-rice#${NIXOSRICE_HOSTNAME}"

sudo nixos-enter -- passwd andy3153
