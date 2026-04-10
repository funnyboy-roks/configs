#!/bin/bash

if [ -e $home/dev/rust/playground ]; then
    echo 'Initialising Playground'
    mkdir $HOME/dev/rust
    cd $HOME/dev/rust
    cargo new --bin playground
    echo $'fn main() {\n    println!("Hello World");\n}' > $HOME/dev/rust/playground/template.rs
fi

if [ "$1" = "--watch" ]; then
    cd ~/dev/rust/playground
    cargo watch -q                                       \
        -w src                                           \
        -w examples                                      \
        -s 'clear -x'                                    \
        -s 'echo -e "-------- $(date +%X) --------\n"' \
        -s 'cargo r -q --example '$2
    exit
fi

example=$(date --rfc-3339=date)
if [ ! -z $1 ]; then
    example=$1
fi

file=$HOME/dev/rust/playground/examples/$example.rs
if [ ! -e $file ]; then
    cp $HOME/dev/rust/playground/template.rs $file
fi
tmux split-window -h -l40% $0 --watch $example
tmux select-pane -t .0
nvim $file
tmux send-keys -t .1 'C-c'
