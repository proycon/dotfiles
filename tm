#!/bin/zsh
tmux -2u attach -t $1 || tmux -2u new -s $1 $1
