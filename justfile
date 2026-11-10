## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Justfile for my configs
## by Andy3153
##

# {{{ Variables
# {{{ Dotfile directories
dotfileRootDir := env("XDG_PROJECTS_DIR", env("HOME", "~") + "/src")

zshDir    := dotfileRootDir + "/sh/andy3153-zshrc"
scriptDir := dotfileRootDir + "/sh/other-shell-scripts"
nvimDir   := dotfileRootDir + "/nvim/andy3153-init.lua"
hyprDir   := dotfileRootDir + "/hyprland/hyprland-rice"
nixosDir  := dotfileRootDir + "/nix/nixos-rice"
# }}}
# }}}

# {{{ Functions
# {{{ Git
[private]
git-pull directory:
  [ -d {{ directory }} ] && git -C {{ directory }} pull --rebase --autostash || true

[private]
git-push directory:
  [ -d {{ directory }} ] && git -C {{ directory }} push || true
# }}}

# {{{ NixOS
[private]
nix-flake-update flakePath:
  nix flake update --flake "{{ flakePath }}" --option access-tokens "github.com=$(gh auth token)"

[private]
nh-os cmd:
  nh os {{ cmd }} -- --impure

[private]
nh-clean cmd nrOfGensToKeep:
  nh clean {{ cmd }} --keep {{ nrOfGensToKeep }}
# }}}

# {{{ Neovim
[private]
nvim-run cmd:
  nvim --headless '+{{ cmd }}' +qa
# }}}
# }}}

# {{{ Recipes
# {{{ Dotfiles
dotfiles-pull:         \
  (git-pull zshDir)    \
  (git-pull scriptDir) \
  (git-pull nvimDir)   \
  (git-pull hyprDir)   \
  (git-pull nixosDir)

dotfiles-push:         \
  (git-push zshDir)    \
  (git-push scriptDir) \
  (git-push nvimDir)   \
  (git-push hyprDir)   \
  (git-push nixosDir)

dotfiles: dotfiles-pull dotfiles-push
# }}}

# {{{ NixOS
nixos-build:  (nh-os "build")
nixos-boot:   (nh-os "boot")
nixos-switch: (nh-os "switch")
nixos-flake:  (nix-flake-update nixosDir)

nixos:              nixos-switch
nixos-update:       nixos-flake nixos-switch
nixos-update-boot:  nixos-flake nixos-boot
nixos-update-build: nixos-flake nixos-build

nixos-clean-system nrOfGensToKeep: (nh-clean "all"  nrOfGensToKeep)
nixos-clean-user   nrOfGensToKeep: (nh-clean "user" nrOfGensToKeep)
nixos-optimise:
  nix store optimise
nixos-repair:
  doas nix-store --verify --check-contents --repair

nixos-clean nrOfGensToKeep:           \
  (nixos-clean-system nrOfGensToKeep) \
  (nixos-clean-user   nrOfGensToKeep) \
  nixos-optimise                      \
  nixos-repair
# }}}

# {{{ Neovim
nvim-lazy:       (nvim-run "Lazy! sync")
nvim-treesitter: (nvim-run "TSInstall all")

nvim: nvim-lazy nvim-treesitter
# }}}

# {{{ Zsh
zsh:
  zsh -ic "plugin-update"
# }}}

# {{{ Default
[default]
default: nixos

switch: nixos
boot:   nixos-boot
build:  nixos-build

update:        dotfiles switch        nvim zsh (nixos-clean "1")
update-boot:   dotfiles boot          nvim zsh (nixos-clean "1")
update-build:  dotfiles build  switch nvim zsh (nixos-clean "1")

upgrade:       dotfiles nixos-update              nvim zsh (nixos-clean "1")
upgrade-boot:  dotfiles nixos-update-boot         nvim zsh (nixos-clean "1")
upgrade-build: dotfiles nixos-update-build switch nvim zsh (nixos-clean "1")
# }}}
# }}}
