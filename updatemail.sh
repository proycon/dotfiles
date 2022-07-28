#!/bin/sh
if [ ! -f /tmp/.maillock ]; then 
    touch /tmp/.maillock
    date
    echo "Checking for new mail..."
    time notmuch new --verbose
    echo "Tagging new mail..."
    time notmuch tag --batch --input=$HOME/dotfiles.private/tags.txt
    #echo "Archiving leftovers..."
    #/home/proycon/bin/inbox2archive.sh &
    echo "done"
    rm /tmp/.maillock
else
    echo "locked">&2
fi
