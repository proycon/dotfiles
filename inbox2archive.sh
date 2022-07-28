#!/bin/bash
#move everything that does not have tag inbox but is in the inbox to Archive
if [ -f /tmp/.inbox2archive ]; then
    echo "inbox2archive already in progress..."
else
    touch /tmp/.inbox2archive
    notmuch tag -inbox 'tag:inbox AND tag:killed'; #things that are killed may not remain in inbox
    notmuch search --output=files 'not tag:inbox' | grep --color=never 'Maildir/cur' >> /tmp/.inbox2archive
    if [ -s /tmp/.inbox2archive ]; then
        cat /tmp/.inbox2archive | xargs mv -t /home/proycon/Maildir/.Archive/cur/
    fi
    echo "" > /tmp/.inbox2archive
    rm /tmp/.inbox2archive
fi
