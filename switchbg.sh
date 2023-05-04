#!/bin/sh

if ps aux | grep swaybg | grep -v grep | grep photo-of-lake; then
    killall swaybg
    swaybg -m fill -i ~/dotfiles/media/mountain-view-krivec-ales.jpg &
elif ps aux | grep swaybg | grep -v grep | grep mountain-view; then
    killall swaybg
    swaybg -m fill -i ~/dotfiles/media/mountain.jpg &
elif ps aux | grep swaybg | grep -v grep | grep mountain.jpg; then
    killall swaybg
    swaybg -m fill -i ~/dotfiles/media/forest.jpg &
else
    killall swaybg
    swaybg -m fill -i ~/dotfiles/media/photo-of-lake-krivec-ales.jpg &
fi
