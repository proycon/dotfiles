#!/bin/sh

CURBG=$(ps aux | grep swaybg | grep -v grep)

case "$CURBG" in
    *photo-of-lake*)
        NEWBG=~/dotfiles/media/mountain-view-krivec-ales.jpg
        ;;
    *mountain-view*)
        NEWBG=~/dotfiles/media/mountain.jpg
        ;;
    *mountain.jpg*)
        NEWBG=~/dotfiles/media/forest.jpg
        ;;
    *forest.jpg*)
        NEWBG=~/dotfiles/media/night-misty-peaks.png
        ;;
    *night-misty-peaks*)
        NEWBG=~/dotfiles/media/paradox_waves_by_neaben.jpg
        ;;
    *paradox_waves*)
        NEWBG=~/dotfiles/media/photo-of-lake-krivec-ales.jpg
        ;;
    *)
        NEWBG=~/dotfiles/media/paradox_waves_by_neaben.jpg
        ;;
esac

if [ -n "$NEWBG" ]; then
    killall swaybg
    echo "setting background $NEWBG" >&2
    swaybg -m fill -i "$NEWBG" &
fi
