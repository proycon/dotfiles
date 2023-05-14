#!/bin/zsh
if [ which "$1" ]; then
    cmd=$1
else
    if [ ! -z "$2" ]; then
        cmd=$2
    fi
fi
tmux attach -t $1 || tmux new -s $1 $cmd
