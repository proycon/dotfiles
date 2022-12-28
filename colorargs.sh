#!/bin/sh

if [ ! -e ~/.light ]; then
    #dark
    FG="#bbbbbb"
    BG="#222222"
    FGSEL="#eeeeee"
    BGSEL="#005577"
else
    #light
    BG="#bbbbbb"
    FG="#222222"
    BGSEL="#eeeeee"
    FGSEL="#005577"
fi

export DMENU_COLORARGS="-nb $BG -nf $FG -sb $BGSEL -sf $FGSEL"
export BEMENU_COLORARGS="--fn 'Monospace 32' --nb $BG --nf $FG --sb $BGSEL --sf $FGSEL"
