#!/bin/bash
HOSTNAME=$(hostname)
if [ "$HOSTNAME" == "mhysa" ]; then
    polybar -c ~/dotfiles/polybar/config primary > ~/.polybar$DISPLAY.out 2> ~/.polybar$DISPLAY.log &
    polybar -c ~/dotfiles/polybar/config secondary > ~/.polybar$DISPLAY.2.out 2> ~/.polybar$DISPLAY.2.log &
else
    polybar -c ~/dotfiles/polybar/config simple > ~/.polybar$DISPLAY.out 2> ~/.polybar$DISPLAY.log
fi
