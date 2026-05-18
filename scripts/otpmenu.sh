#!/usr/bin/env bash

. ~/dotfiles/scripts/colorargs.sh

shopt -s nullglob globstar

if command -v wtype >/dev/null 2>/dev/null; then
    typeit=1
else
    typeit=0
fi
if [ "$1" == "--type" ]; then
	typeit=1
	shift
fi

export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python 

export PATH=~/bin:$PATH
target=$(nitropy nk3 secrets list | tail -n +1 | cut  -f 1 | cut -d " " -f 2 | bemenu -p "Target" --fn "$BEMENU_FONT" -l 10 $BEMENU_COLORARGS )
[ -n "$target" ] || exit

password=$(nitropy nk3 secrets get-otp "$target" | tail -n 1)

if [ "$typeit" -eq 0 ]; then
  if [ -n "$password" ]; then
      echo -n "$password" | wl-copy
      mpv --really-quiet "$HOME/dotfiles/media/unlock2.wav" &
  else
      mpv --really-quiet "$HOME/dotfiles/media/boing.wav" &
  fi
else
  if [ -n "$password" ]; then
      wtype "$password"
      mpv --really-quiet "$HOME/dotfiles/media/unlock2.wav" &
  else
      mpv --really-quiet "$HOME/dotfiles/media/boing.wav" &
  fi
fi
