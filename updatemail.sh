#!/bin/sh
if [ ! -f /tmp/.maillock ]; then 
    touch /tmp/.maillock
    date
    echo "Checking for new mail..."
    time notmuch new
    echo "Tagging new mail..."
    time afew -n -t 
    #echo "Moving mail to folders..."
    #afew -a --move-mails
    #echo "Archiving leftovers..."
    #/home/proycon/bin/inbox2archive.sh &
    echo "done"
    rm /tmp/.maillock
else
    echo "locked">&2
fi
