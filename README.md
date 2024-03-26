<!-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}: -->
# nixos-rice
These are the configuration files for getting a NixOS system up and running my way (to be finished)

<!-- {{{ Useful extra things -->
## Useful extra things
<!-- {{{ Partition setup shell script -->
### Partition setup shell script
In order to automate partition setup as well, the `partition-setup.sh` script is there for you. This was made only for me to use, since other people might want to set up their partitions completely differently, but, hey, it's there.
<!-- }}} -->

<!-- {{{ Mount partitions shell script -->
### Mount partitions shell script
If you need to mount the partitions in a live environment post-install and **you have used the `partition-setup.sh` script to create your partitions**, the `mount-partitions.sh` script is there for you.
<!-- }}} -->

<!-- {{{ Useful commands so I don't have to search for them later -->
### Useful commands so I don't have to search for them later
<!-- {{{ Mount configs through SSHFS for live environment -->
<details><summary>Mount configs through SSHFS for live environment</summary>

```bash
mkdir -p /mnt2/nixconfig
sshfs -o allow_other,idmap=user andy3153h@192.168.122.1:/home/andy3153h/src/nixos/nixos-rice /mnt2/nixconfig
nixos-generate-config --root /mnt

rm -r /mnt/etc/nixos
cp -r /mnt2/nixconfig/etc/nixos/ /mnt/etc

mkdir -p /mnt/home/andy3153/.config
rm -r /mnt/home/andy3153/.config/home-manager
cp -r /mnt2/nixconfig/home/andy3153/.config/home-manager/ /mnt/home/andy3153/.config/

rm /mnt/etc/nixos/.setup-done
rm -r /mnt/home/andy3153/src

#ln -s /mnt2/nixconfig/etc/nixos/ /mnt/etc
#
#mkdir -p /mnt/home/andy3153/.config
#rm -r /mnt/home/andy3153/.config/home-manager
#ln -s /mnt2/nixconfig/home/andy3153/.config/home-manager/ /mnt/home/andy3153/.config/
```
</details>
<!-- }}} -->

<!-- {{{ Copy configs for live environment -->
<details><summary>Copy configs for live environment</summary>

```bash
mkdir -p /mnt3
mount /dev/sdc1 /mnt
nixos-generate-config --root /mnt

rm -r /mnt/etc/nixos
cp -r /mnt3/src/nixos/nixos-rice/etc/nixos/ /mnt/etc

mkdir -p /mnt/home/andy3153/.config
rm -r /mnt/home/andy3153/.config/home-manager
cp -r /mnt3/src/nixos/nixos-rice/home/andy3153/.config/home-manager/ /mnt/home/andy3153/.config/

rm /mnt/etc/nixos/.setup-done
rm -r /mnt/home/andy3153/src
```
</details>
<!-- }}} -->

<!-- {{{ Mount configs through SSHFS for already-installed system -->
<details><summary>Mount configs through SSHFS for already-installed system</summary>

```bash
mkdir -p /mnt/nixconfig
sshfs -o allow_other,idmap=user andy3153h@192.168.122.1:/home/andy3153h/src/nixos/nixos-rice /mnt/nixconfig

rm -rf /etc/nixos
ln -s /mnt/nixconfig/etc/nixos/ /etc

rm -rf /home/andy3153/.config/home-manager
ln -s /mnt/nixconfig/home/andy3153/.config/home-manager/ ~andy3153/.config/
```
</details>
<!-- }}} -->

<!-- {{{ Mount configs through SSHFS to edit configs from another machine -->
<details><summary>Mount configs through SSHFS for already-installed system</summary>

```bash
sshfs -o allow_other,idmap=user root@catfish:/ /mnt/sshfs
```
</details>
<!-- }}} -->

<!-- {{{ System update -->
<details><summary>System update</summary>

```bash
doas nix flake update /etc/nixos
doas nixos-rebuild switch --flake /etc/nixos#andy3153-nixos

nix flake update ~/.config/home-manager
home-manager switch --impure --flake ~/.config/home-manager/
```

Run one after the other
```bash
doas nix flake update /etc/nixos && doas nixos-rebuild switch --flake /etc/nixos#andy3153-nixos
nix flake update ~/.config/home-manager && home-manager switch --impure --flake ~/.config/home-manager/
```
</details>
<!-- }}} -->

<!-- {{{ Garbage collection -->
<details><summary>Garbage collection</summary>

```bash
nix-collect-garbage       # delete old packages
nix-collect-garbage -d    # delete old roots
doas nixos-rebuild switch # recommended after deleting old roots
```
</details>
<!-- }}} -->

<!-- {{{ Optimize Nix store -->
<details><summary>Optimize Nix store</summary>

```bash
nix-store --optimise
```
</details>
<!-- }}} -->

<!-- {{{ nixos-enter somehow doesn't pick up $PATH right -->
<details><summary>nixos-enter somehow doesn't pick up $PATH right</summary>

```bash
nixos-enter --root /mnt
export PATH=/nix/var/nix/profiles/system/sw/sbin/:/nix/var/nix/profiles/system/sw/bin/:$PATH
```
</details>
<!-- }}} -->
<!-- }}} -->
<!-- }}} -->
