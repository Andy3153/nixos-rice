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
  [ -d {{ directory }} ] && GIT_TERMINAL_PROMPT=0 git -C {{ directory }} pull --rebase --autostash || true

[private]
git-push directory:
  [ -d {{ directory }} ] && GIT_TERMINAL_PROMPT=0 git -C {{ directory }} push || true
# }}}

# {{{ NixOS
# {{{ Nix
[private]
nix-repl flakePath:
  nix repl nixpkgs "{{ flakePath }}" --impure

[private]
nix-flake-update flakePath:
  nix flake update --flake "{{ flakePath }}" --option access-tokens "github.com=$(gh auth token)"
# }}}

# {{{ Nh
[private]
nh-os cmd:
  nh os {{ cmd }}

[private]
nh-os-impure cmd:
  nh os {{ cmd }} -- --impure

[private]
nh-clean cmd nrOfGensToKeep:
  nh clean {{ cmd }} --keep {{ nrOfGensToKeep }}
# }}}

# {{{ Clean
[private]
nixos-clean-system nrOfGensToKeep: (nh-clean "all"  nrOfGensToKeep)

[private]
nixos-clean-user   nrOfGensToKeep: (nh-clean "user" nrOfGensToKeep)

[private]
nixos-optimise:
  nix store optimise

[private]
nixos-repair:
  doas nix-store --verify --check-contents --repair
# }}}
# }}}

# {{{ Neovim
[private]
nvim-run cmd:
  nvim --headless '+{{ cmd }}' +qa
# }}}

# {{{ Zsh
[private]
zsh-run cmd:
  zsh -ic '{{ cmd }}'
# }}}
# }}}

# {{{ Recipes
# {{{ Dotfiles
# Pull all changes made to the dotfiles
dotfiles-pull:         \
  (git-pull zshDir)    \
  (git-pull scriptDir) \
  (git-pull nvimDir)   \
  (git-pull hyprDir)   \
  (git-pull nixosDir)

# Push all changes made to the dotfiles
dotfiles-push:         \
  (git-push zshDir)    \
  (git-push scriptDir) \
  (git-push nvimDir)   \
  (git-push hyprDir)   \
  (git-push nixosDir)

# `dotfiles-pull`, `dotfiles-push`
dotfiles: dotfiles-pull dotfiles-push
# }}}

# {{{ NixOS
# {{{ Build
# Build the new NixOS configuration (leaves a 'result' symlink in cwd)
build:  (nh-os-impure "build")

# Build the new NixOS configuration and make it the default at boot
boot:   (nh-os-impure "boot")

# Build and activate the new NixOS configuration and make it the default at boot
switch: (nh-os-impure "switch")

# Update the NixOS system flake's lock file
flake:  (nix-flake-update nixosDir)
# }}}

# {{{ Tools
# Clean all but the last `nrOfGensToKeep` system and user NixOS profiles, then optimize and repair the Nix store
clean nrOfGensToKeep:                 \
  (nixos-clean-system nrOfGensToKeep) \
  (nixos-clean-user   nrOfGensToKeep) \
  nixos-optimise                      \
  nixos-repair

# List the available NixOS generations
generations: (nh-os "info")

# Start an interactive environment for evaluating Nix expressions and load the system flake
repl:        (nix-repl nixosDir)
# }}}
# }}}

# {{{ Neovim
# Update all Neovim plugins
nvim-lazy:       (nvim-run "Lazy! sync")

# Update all Neovim Treesitter parsers
nvim-treesitter: (nvim-run "TSInstall all")

# `nvim-lazy`, `nvim-treesitter`
nvim: nvim-lazy nvim-treesitter
# }}}

# {{{ Zsh
# Update all Zsh plugins
zsh: (zsh-run "plugin-update")
# }}}

# {{{ Full system update & upgrade
# {{{ Update
# {{{ Softdate
#                `dotfiles`,          `switch`
softdate:         dotfiles             switch

#                `dotfiles`,          `boot`
softdate-boot:    dotfiles             boot

#                `dotfiles`,          `build`, `switch`
softdate-build:   dotfiles             build    switch
# }}}

# {{{ Update
#                `dotfiles`,          `switch`,          `nvim`, `zsh`
update:           dotfiles             switch             nvim    zsh

#                `dotfiles`,          `boot`,            `nvim`, `zsh`
update-boot:      dotfiles             boot               nvim    zsh

#                `dotfiles`,          `build`, `switch`, `nvim`, `zsh`
update-build:     dotfiles             build    switch    nvim    zsh
# }}}

# {{{ Harddate
#                `dotfiles`,          `switch`,          `nvim`, `zsh`, `(clean "1")`
harddate:         dotfiles             switch             nvim    zsh    (clean "1")

#                `dotfiles`,          `boot`,            `nvim`, `zsh`, `(clean "1")`
harddate-boot:    dotfiles             boot               nvim    zsh    (clean "1")

#                `dotfiles`,          `build`, `switch`, `nvim`, `zsh`, `(clean "1")`
harddate-build:   dotfiles             build    switch    nvim    zsh    (clean "1")
# }}}
# }}}

# {{{ Upgrade
# {{{ Softgrade
#                `dotfiles`, `flake`, `switch`
softgrade:        dotfiles    flake    switch

#                `dotfiles`, `flake`, `boot`
softgrade-boot:   dotfiles    flake    boot

#                `dotfiles`, `flake`, `build`, `switch`
softgrade-build:  dotfiles    flake    build    switch
# }}}

# {{{ Upgrade
#                `dotfiles`, `flake`, `switch`,          `nvim`, `zsh`
upgrade:          dotfiles    flake    switch             nvim    zsh

#                `dotfiles`, `flake`, `boot`,            `nvim`, `zsh`
upgrade-boot:     dotfiles    flake    boot               nvim    zsh

#                `dotfiles`, `flake`, `build`, `switch`, `nvim`, `zsh`
upgrade-build:    dotfiles    flake    build    switch    nvim    zsh
# }}}

# {{{ Hardgrade
#                `dotfiles`, `flake`, `switch`,          `nvim`, `zsh`, `(clean "1")`
hardgrade:        dotfiles    flake    switch             nvim    zsh    (clean "1")

#                `dotfiles`, `flake`, `boot`,            `nvim`, `zsh`, `(clean "1")`
hardgrade-boot:   dotfiles    flake    boot               nvim    zsh    (clean "1")

#                `dotfiles`, `flake`, `build`, `switch`, `nvim`, `zsh`, `(clean "1")`
hardgrade-build:  dotfiles    flake    build    switch    nvim    zsh    (clean "1")
# }}}
# }}}
# }}}

# {{{ Default
# `switch`
[default]
default: switch
# }}}
# }}}
