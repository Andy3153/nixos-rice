#!/usr/bin/env bash
# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

# {{{ Variables (CHANGE ACCORDING TO YOUR SETUP)
#export _hostname="nixvm"
#export _disk="/dev/vda"
#export _bootpart="${_disk}1"
#export _ospart="${_disk}2"
#export _oscryptvol="/dev/mapper/${_hostname}-crypt"

#export _hostname="milog"
#export _disk="/dev/sda"
#export _bootpart="${_disk}1"
#export _ospart="${_disk}2"
#export _oscryptvol="/dev/mapper/${_hostname}-crypt"

export _hostname="catfish"
export _disk="/dev/sda"
export _bootpart="${_disk}1"
export _ospart="${_disk}2"
export _oscryptvol="/dev/mapper/${_hostname}-crypt"
# }}}

# {{{ Initial formatting and mounting
parted --script "${_disk}" mklabel gpt
parted --script "${_disk}" mkpart \""EFI System Partition"\" fat32 0% 2GiB
parted --script "${_disk}" mkpart \""${_hostname}-crypt"\" ext4 2GiB 100%
parted --script "${_disk}" set 1 esp on

mkfs.fat -F 32 -n "ESP" "${_bootpart}"

cryptsetup --batch-mode --label "${_hostname}-crypt" luksFormat "${_ospart}"
cryptsetup luksOpen "${_ospart}" "${_hostname}-crypt"

mkfs.btrfs -L "${_hostname}" "${_oscryptvol}"

mount "${_oscryptvol}" /mnt
cd /mnt
# }}}

# {{{ Creation of subvolumes
btrfs subvolume create root
btrfs subvolume create nix
btrfs subvolume create home
btrfs subvolume create swap
btrfs subvolume create snapshots
btrfs subvolume create snapshots.externalhdd
btrfs subvolume create var-cache
btrfs subvolume create var-log
btrfs subvolume create var-tmp
btrfs subvolume create vms
btrfs subvolume create games
btrfs subvolume create torrents
# }}}

# {{{ Unmounting subvolid5 and mounting the root subvolume
cd /
umount /mnt
mount -o subvol=/root "${_oscryptvol}" /mnt

# go back to /mnt
cd /mnt
# }}}

# {{{ Mounting the boot partition
mkdir -p boot
mount "${_bootpart}" boot
# }}}

# {{{ Mounting the other subvolumes
mkdir -p .btrfs-root
mount -o subvol=/ "${_oscryptvol}" .btrfs-root

mkdir -p nix
mount -o subvol=/nix "${_oscryptvol}" nix

mkdir -p home
mount -o subvol=/home "${_oscryptvol}" home

mkdir -p .swap
mount -o subvol=/swap "${_oscryptvol}" .swap

mkdir -p .snapshots
mount -o subvol=/snapshots "${_oscryptvol}" .snapshots

mkdir -p .snapshots.externalhdd
mount -o subvol=/snapshots.externalhdd "${_oscryptvol}" .snapshots.externalhdd

mkdir -p var/cache
mount -o subvol=/var-cache "${_oscryptvol}" var/cache

mkdir -p var/log
mount -o subvol=/var-log "${_oscryptvol}" var/log

mkdir -p var/tmp
mount -o subvol=/var-tmp "${_oscryptvol}" var/tmp

mkdir -p var/lib/libvirt/images
mount -o subvol=/vms "${_oscryptvol}" var/lib/libvirt/images

mkdir -p home/andy3153/games
mount -o subvol=/games "${_oscryptvol}" home/andy3153/games

mkdir -p home/andy3153/torrents
mount -o subvol=/torrents "${_oscryptvol}" home/andy3153/torrents
# }}}

# {{{ Set properties for the subvolumes
cd .btrfs-root

# compression
btrfs property set root compression zstd
btrfs property set home compression zstd
btrfs property set snapshots compression zstd
btrfs property set snapshots.externalhdd compression zstd
btrfs property set var-cache compression zstd
btrfs property set var-log compression zstd
btrfs property set var-tmp compression zstd
btrfs property set games compression zstd
btrfs property set torrents compression zstd

# no copy-on-write
chattr -R +C swap
chattr -R +C vms

# go back to /mnt
cd ..
# }}}

# {{{ Create swapfile
cd .swap
btrfs filesystem mkswapfile --size 2G swapfile
swapon swapfile

# go back to /mnt
cd ..
# }}}
