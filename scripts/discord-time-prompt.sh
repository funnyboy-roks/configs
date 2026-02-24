#!/bin/bash
#
# Prompts (using dmenu) for a time and then copies the discord format
# to the keyboard and prints to stdout

dt () {
    local args
    local flag
    if [[ "$1" =~ ^(-[dDtTfFR])$ ]]; then
        flag="${1/-/:}"
        args="${@:2}"
    fi
    : ${args:=${*-now}}
    out=$(date +"t:%s$flag" -d "$args")
    pretty_out=$(date -d "$args")
    echo "<$out>"
    printf "<$out>" | wl-copy
    notify-send 'Copied to clipboard' "$pretty_out\n\n&lt;$out&gt;"
}

dt $(echo "$1" "$(fuzzel -d -l 0 < /dev/null)" | cut -d' ' -f1-)
