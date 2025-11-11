#!/bin/bash
# Create the links for all the config files to this directory
# _Note: This will rename any previous dir to "${DIR}_OLD"_

function mkln () {
    from="$1"
    to="$2"

    if ! [ -L "$to" ]; then # Move if it is not a link
        mv "$to" "${to}_OLD" > /dev/null 2> /dev/null && echo "Moved $to to ${to}_OLD"
    else # Otherwise, yeet it
        target="$(readlink -f "$to")"
        rm "$to" &> /dev/null && echo "Removed previous link ${to/$HOME/~} -> ${target/$HOME/~}"
    fi
    ln -s "$(pwd)/$from" "$to"
}

mkln "i3"                   "$HOME/.config/i3"
mkln "zsh"                  "$HOME/.zsh"
mkln "fish"                 "$HOME/.config/fish"
mkln "zsh/.zshrc"           "$HOME/.zshrc"
mkln ".vimrc"               "$HOME/.vimrc"
mkln ".ideavimrc"           "$HoME/.ideavimrc"
mkln "alacritty"            "$HOME/.config/alacritty"
mkln "nvim"                 "$HOME/.config/nvim"
mkln "ulauncher"            "$HOME/.config/ulauncher"
mkln "autorandr"            "$HOME/.config/autorandr"
mkln "picom"                "$HOME/.config/picom"
mkln "user-dirs.dirs"       "$HOME/.config/user-dirs.dirs"
mkln ".xinitrc"             "$HOME/.xinitrc"
mkln ".xmodmap"             "$HOME/.xmodmap"
mkln ".cargo/config.toml"   "$HOME/.cargo/config.toml"
mkln "i3/betterlockscreen"  "$HOME/.config/betterlockscreen/betterlockscreenrc"
mkln "scripts"              "$HOME/scripts"
mkln "dlauncher"            "$HOME/.config/dlauncher"
mkln ".tmux.conf"           "$HOME/.tmux.conf"
mkln "tmux"                 "$HOME/.config/tmux"

# These need sudo to run, but there here for documentation
mkln "lemurs/config.toml"   "/etc/lemurs/config.toml"
mkln "lemurs/wms"           "/etc/lemurs/wms"

for path in $(find "~/.mozilla/firefox" -maxdepth 1 -iname '*.dev-edition-default*'); do
    mkdir "$path/chrome"
    mkln "firefox/userChrome.css" "$path/chrome/userChrome.css"
done
