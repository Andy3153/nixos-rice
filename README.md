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
<!-- {{{ System update -->
<details><summary>System update</summary>

```console
nh os switch --update -- --impure
```
</details>
<!-- }}} -->

<!-- {{{ Garbage collection -->
<details><summary>Garbage collection</summary>

```console
nh clean all --keep 2 && nh clean user --keep 2
```
</details>
<!-- }}} -->

<!-- {{{ Optimise Nix store -->
<details><summary>Optimise Nix store</summary>

```console
doas nix store optimise
```
</details>
<!-- }}} -->

<!-- {{{ Manually add a file to the Nix store -->
<details><summary>Manually add a file to the Nix store</summary>

```console
nix-store --add-fixed sha256 filename
```
</details>
<!-- }}} -->

<!-- {{{ Get values set in configuration
<details><summary>Get values set in configuration</summary>

- `nix eval`
```console
nix eval --no-eval-cache ~/src/nixos/nixos-rice\#nixosConfigurations.HOSTNAME.config.sdfsdfsdfsdf
```

- `nix repl`
```console
nix repl

:lf /home/andy3153/src/nixos/nixos-rice
nixosConfigurations.HOSTNAME.config.sdfsdfsdfsdf.tabcompletion
```
</details>
<!-- }}} -->

<!-- {{{ nixos-enter somehow doesn't pick up $PATH right -->
<details><summary>nixos-enter somehow doesn't pick up $PATH right</summary>

```console
nixos-enter --root /mnt
export PATH=/nix/var/nix/profiles/system/sw/sbin/:/nix/var/nix/profiles/system/sw/bin/:$PATH
```
</details>
<!-- }}} -->
<!-- }}} -->
<!-- }}} -->
