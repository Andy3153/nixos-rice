## vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}:
##
## NixOS post-install script
##

# Check if it's the first time the script ran
if [ -e "/etc/nixos/.setup-done" ]
then exit 1
else

# {{{ Variables
# {{{ Basic
user="andy3153"
userHome="/home/$user"

ghlink="https://github.com/Andy3153"
# }}}

# {{{ Programs
ping="${pkgs.unixtools.ping}/bin/ping"
git="${pkgs.git}/bin/git"
su="${pkgs.su}/bin/su"
nix="${pkgs.nix}/bin/nix"
runtimeShell="${pkgs.runtimeShell}"
# }}}
# }}}

  # {{{ Check internet connection
  if ! $ping -q -c1 1.1.1.1 &> /dev/null
  then print "No internet!" ; exit 1
  fi
  # }}}

  # {{{ Create the folder structure
  mkdir -p "$userHome/src $userHome/.config"
  cd "$userHome/src"
  mkdir -p "nixos/nixos-rice" "hyprland/hyprland-rice" "nvim/andy3153-init.lua" "sh/andy3153-zshrc"
  # }}}

  # {{{ Clone the Git repos
  if [ -z "$(ls -A "nixos/nixos-rice")" ]
  then $git clone "$ghlink/nixos-rice" "nixos/nixos-rice"
  fi

  if [ -z "$(ls -A "hyprland/hyprland-rice")" ]
  then $git clone "$ghlink/hyprland-rice" "hyprland/hyprland-rice"
  fi

  if [ -z "$(ls -A "nvim/andy3153-init.lua")" ]
  then $git clone "$ghlink/andy3153-init.lua" "nvim/andy3153-init.lua"
  fi

  if [ -z "$(ls -A "sh/andy3153-zshrc")" ]
  then $git clone "$ghlink/andy3153-zshrc" "sh/andy3153-zshrc"
  fi
  # }}}

  $su "$user" --shell "$runtimeShell" -c "$nix run home-manager/master -- init"            # Initialize HM for user

  # {{{ Link NixOS configs in their place
  rm -r "/etc/nixos 2> /dev/null"
  ln -s "$userHome/src/nixos/nixos-rice/etc/nixos" "/etc/"

  rm -r "$userHome/.config/home-manager 2> /dev/null"
  ln -s "$userHome/src/nixos/nixos-rice/home/andy3153/.config/home-manager/" "$userHome/.config/"
  # }}}

  # {{{ Finishing steps
  chown -R "$user":"$user" "$userHome"                             # Make sure user owns his files
  $su "$user" --shell "$runtimeShell" -c "$nix run home-manager/master -- switch --impure" # Install HM for user
  touch "/etc/nixos/.setup-done"                                   # Make sure it's the last time this script runs
  # }}}
fi
