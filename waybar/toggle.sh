#!/usr/bin/env sh

# Create/remove a file in the directory (current file name with _set)
if rm "$0_hidden"; then
    swaymsg bar mode dock primary
else
    swaymsg bar mode invisible primary
    touch "$0_hidden"
fi
