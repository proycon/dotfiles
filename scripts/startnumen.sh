#!/bin/sh
killall speech 2> /dev/null
paplay ~/dotfiles/media/glass.ogg

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    ENVPHRASES=~/dotfiles/numen/phrases/environment.hyprland.phrases
elif [ -n "$SXMO_WM" ]; then
    ENVPHRASES=~/dotfiles/numen/phrases/environment.sxmo-sway.phrases
fi
if [ "$1" = "--house" ] && [ -f ~/lighthome/config/house.phrases ]; then
    HOUSEPHRASES=~/lighthome/config/house.idle.phrases
fi
if [ "$1" = "--timeout" ] || [ "$2" = "--timeout" ]; then
    TIMEOUT="timeout --kill-after=12s --signal=9 10s"
else
    TIMEOUT=""
fi
$TIMEOUT numen /etc/numen/phrases/character.phrases /etc/numen/phrases/control.phrases /etc/numen/phrases/voice.phrases ~/dotfiles/numen/phrases/extra.character.phrases "$ENVPHRASES" $HOUSEPHRASES
paplay ~/dotfiles/media/glass_low.ogg

