#!/bin/bash
d=$(realpath "$1")
if [[ "$d" == "$HOME" ]]; then
    echo "~"
else
    if [ -d .git ]; then
        basename "$d"
    else
        oldpath=$(pwd)
        cd "$d" || exit 1
        g=$(git rev-parse --show-toplevel 2> /dev/null)
        if [ $? -eq 0 ]; then
            basename "$g"
        else
            basename "$d"
        fi
        cd "$oldpath"
    fi
fi

