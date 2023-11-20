#!/usr/bin/env bash
# vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:

# {{{ Variables (CHANGE ACCORDING TO YOUR SETUP)
#export _hostname="nixvm"
#export _disk="/dev/vda"
#export _bootpart="${_disk}1"
#export _ospart="${_disk}2"
#export _oscryptvol="/dev/mapper/${_hostname}-crypt"

export _hostname="milog"
export _disk="/dev/sda"
export _bootpart="${_disk}1"
export _ospart="${_disk}2"
export _oscryptvol="/dev/mapper/${_hostname}-crypt"
# }}}

# {{{ Unlock LUKS container
cryptsetup luksOpen "${_ospart}" "${_hostname}-crypt"
# }}}

# {{{ Mount root subvolume
mount -o subvol=/root "${_oscryptvol}" /mnt
cd /mnt
# }}}

# {{{ Mount boot partition
mount "${_bootpart}" boot
# }}}

# {{{ Mount the Btrfs subvolumes
mount -o subvol=/ "${_oscryptvol}" .btrfs-root
mount -o subvol=/nix "${_oscryptvol}" nix
mount -o subvol=/home "${_oscryptvol}" home
mount -o subvol=/swap "${_oscryptvol}" .swap
mount -o subvol=/snapshots "${_oscryptvol}" .snapshots
mount -o subvol=/snapshots.externalhdd "${_oscryptvol}" .snapshots.externalhdd
mount -o subvol=/var-cache "${_oscryptvol}" var/cache
mount -o subvol=/var-log "${_oscryptvol}" var/log
mount -o subvol=/var-tmp "${_oscryptvol}" var/tmp
mount -o subvol=/vms "${_oscryptvol}" var/lib/libvirt/images
mount -o subvol=/games "${_oscryptvol}" home/andy3153/games
mount -o subvol=/torrents "${_oscryptvol}" home/andy3153/torrents
# }}}
