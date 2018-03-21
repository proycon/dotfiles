#!/bin/bash
HOSTNAME=$(hostname)
if [[ "$HOSTNAME" == "mhysa" ]]; then
    #good as-is
    cp ~/dotfiles/i3/config.base ~/dotfiles/i3/config
else
    #remove multihead stuff
    grep -v MULTIHEAD ~/dotfiles/i3/config.base > ~/dotfiles/i3/config
fi
