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
    echo "<$out>"
    printf "<$out>" | xclip -i -selection clipboard
    notify-send 'Copied to clipboard' "&lt;$out&gt;"
}

dt $(echo "$1" "$(dmenu -fn 'Anonymous Pro-24' < /dev/null)" | cut -d' ' -f1-)
