#!/bin/sh
killall speech
paplay ~/dotfiles/media/glass.ogg

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    ENVPHRASES=~/dotfiles/numen/phrases/environment.hyprland.phrases
elif [ -n "$SXMO_WM" ]; then
    ENVPHRASES=~/dotfiles/numen/phrases/environment.sxmo-sway.phrases
fi
numen /etc/numen/phrases/character.phrases /etc/numen/phrases/control.phrases /etc/numen/phrases/voice.phrases ~/dotfiles/numen/phrases/extra.character.phrases "$ENVPHRASES" ~/dotfiles/numen/phrases/house.phrases
paplay ~/dotfiles/media/glass_low.ogg

