## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## Justfile for my configs
## by Andy3153
##

# {{{ Settings
set indentation := "  "
set lazy
# }}}

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
# {{{ Help
[private]
just-print arg:
  @just --justfile {{ justfile() }} --list-heading $'NixOS Rice System Tools:\n\n' --list-prefix "• " --unsorted {{ arg }}
# }}}

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
# {{{ Help
# Show this help screen
[group("help")]
help:        (just-print "--list --group help")

# Show all the available tool groups
[group("help")]
groups: (just-print "--groups")

# Show a list of all the available tools in group `group`
[group("help")]
group group: (just-print "--list --group " + group)

# Show a list of all the available tools in all present groups
[group("help")]
list:        (just-print "--list")
# }}}

# {{{ Dotfiles
# Pull all changes made to the dotfiles
[group("dotfiles")]
dotfiles-pull:         \
  (git-pull zshDir)    \
  (git-pull scriptDir) \
  (git-pull nvimDir)   \
  (git-pull hyprDir)   \
  (git-pull nixosDir)

# Push all changes made to the dotfiles
[group("dotfiles")]
dotfiles-push:         \
  (git-push zshDir)    \
  (git-push scriptDir) \
  (git-push nvimDir)   \
  (git-push hyprDir)   \
  (git-push nixosDir)

# `dotfiles-pull`, `dotfiles-push`
[group("dotfiles")]
dotfiles: dotfiles-pull dotfiles-push
# }}}

# {{{ NixOS
# {{{ Build
# Build the new NixOS configuration (leaves a 'result' symlink in cwd)
[group("nixos-build")]
build:  (nh-os-impure "build")

# Build the new NixOS configuration and make it the default at boot
[group("nixos-build")]
boot:   (nh-os-impure "boot")

# Build and activate the new NixOS configuration and make it the default at boot
[group("nixos-build")]
switch: (nh-os-impure "switch")

# Update the NixOS system flake's lock file
[group("nixos-build")]
flake:  (nix-flake-update nixosDir)
# }}}

# {{{ Tools
# Clean all but the last `nrOfGensToKeep` system and user NixOS profiles, then optimize and repair the Nix store
[group("nixos-tools")]
clean nrOfGensToKeep:                 \
  (nixos-clean-system nrOfGensToKeep) \
  (nixos-clean-user   nrOfGensToKeep) \
  nixos-optimise                      \
  nixos-repair

# List the available NixOS generations
[group("nixos-tools")]
generations: (nh-os "info")

# Start an interactive environment for evaluating Nix expressions and load the system flake
[group("nixos-tools")]
repl:        (nix-repl nixosDir)
# }}}
# }}}

# {{{ Neovim
# Update all Neovim plugins
[group("neovim")]
nvim-lazy:       (nvim-run "Lazy! sync")

# Update all Neovim Treesitter parsers
[group("neovim")]
nvim-treesitter: (nvim-run "TSInstall all")

# `nvim-lazy`, `nvim-treesitter`
[group("neovim")]
nvim: nvim-lazy nvim-treesitter
# }}}

# {{{ Zsh
# Update all Zsh plugins
[group("zsh")]
zsh: (zsh-run "plugin-update")
# }}}

# {{{ Full system update & upgrade
# {{{ Update
# {{{ Softdate
#                `dotfiles`,          `switch`
[group("system-update-soft")]
softdate:         dotfiles             switch

#                `dotfiles`,          `boot`
[group("system-update-soft")]
softdate-boot:    dotfiles             boot

#                `dotfiles`,          `build`, `switch`
[group("system-update-soft")]
softdate-build:   dotfiles             build    switch
# }}}

# {{{ Update
#                `dotfiles`,          `switch`,          `nvim`, `zsh`
[group("system-update")]
update:           dotfiles             switch             nvim    zsh

#                `dotfiles`,          `boot`,            `nvim`, `zsh`
[group("system-update")]
update-boot:      dotfiles             boot               nvim    zsh

#                `dotfiles`,          `build`, `switch`, `nvim`, `zsh`
[group("system-update")]
update-build:     dotfiles             build    switch    nvim    zsh
# }}}

# {{{ Harddate
#                `dotfiles`,          `switch`,          `nvim`, `zsh`, `(clean "1")`
[group("system-update-hard")]
harddate:         dotfiles             switch             nvim    zsh    (clean "1")

#                `dotfiles`,          `boot`,            `nvim`, `zsh`, `(clean "1")`
[group("system-update-hard")]
harddate-boot:    dotfiles             boot               nvim    zsh    (clean "1")

#                `dotfiles`,          `build`, `switch`, `nvim`, `zsh`, `(clean "1")`
[group("system-update-hard")]
harddate-build:   dotfiles             build    switch    nvim    zsh    (clean "1")
# }}}
# }}}

# {{{ Upgrade
# {{{ Softgrade
#                `dotfiles`, `flake`, `switch`
[group("system-upgrade-soft")]
softgrade:        dotfiles    flake    switch

#                `dotfiles`, `flake`, `boot`
[group("system-upgrade-soft")]
softgrade-boot:   dotfiles    flake    boot

#                `dotfiles`, `flake`, `build`, `switch`
[group("system-upgrade-soft")]
softgrade-build:  dotfiles    flake    build    switch
# }}}

# {{{ Upgrade
#                `dotfiles`, `flake`, `switch`,          `nvim`, `zsh`
[group("system-upgrade")]
upgrade:          dotfiles    flake    switch             nvim    zsh

#                `dotfiles`, `flake`, `boot`,            `nvim`, `zsh`
[group("system-upgrade")]
upgrade-boot:     dotfiles    flake    boot               nvim    zsh

#                `dotfiles`, `flake`, `build`, `switch`, `nvim`, `zsh`
[group("system-upgrade")]
upgrade-build:    dotfiles    flake    build    switch    nvim    zsh
# }}}

# {{{ Hardgrade
#                `dotfiles`, `flake`, `switch`,          `nvim`, `zsh`, `(clean "1")`
[group("system-upgrade-hard")]
hardgrade:        dotfiles    flake    switch             nvim    zsh    (clean "1")

#                `dotfiles`, `flake`, `boot`,            `nvim`, `zsh`, `(clean "1")`
[group("system-upgrade-hard")]
hardgrade-boot:   dotfiles    flake    boot               nvim    zsh    (clean "1")

#                `dotfiles`, `flake`, `build`, `switch`, `nvim`, `zsh`, `(clean "1")`
[group("system-upgrade-hard")]
hardgrade-build:  dotfiles    flake    build    switch    nvim    zsh    (clean "1")
# }}}
# }}}
# }}}

# {{{ Default
# `switch`
[group("default")]
[default]
default: switch
# }}}
# }}}
