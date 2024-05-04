#!/usr/bin/env bash

. ~/dotfiles/scripts/colorargs.sh

shopt -s nullglob globstar

typeit=0
if [ "$1" == "--type" ]; then
	typeit=1
	shift
fi

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | bemenu -p "Target" --fn "$BEMENU_FONT" -l 10 $BEMENU_COLORARGS )

[ -n "$password" ] || exit

if [ $typeit -eq 0 ]; then
	if pass show -c "$password" 2>/dev/null; then
        mpv --really-quiet "$HOME/dotfiles/media/unlock2.wav" &
    else
        mpv --really-quiet "$HOME/dotfiles/media/boing.wav" &
    fi
else
	if pass show "$password" | { IFS= read -r pass; printf %s "$pass"; } | ydotool type --file -; then
        mpv --really-quiet "$HOME/dotfiles/media/unlock2.wav" &
    fi
fi

