#!/bin/bash

if [ -z $1 ]; then
    echo "Usage: $0 <layout>" >&2
    exit 1
fi

path="$HOME/.config/sway/layouts/$1"

if [ ! -e "$path" ]; then
    echo "Layout does not exist: '$1'" >&2
    exit 1
fi

ln -sf "layouts/$1" "$HOME/.config/sway/outputs"
swaymsg reload
