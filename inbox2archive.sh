#!/bin/sh
#move everything that does not have tag inbox but is in the inbox to Archive
if [ -f /tmp/.inbox2archive ]; then
    echo "inbox2archive already in progress..."&2
else
    touch /tmp/.inbox2archive
    echo "Ensure all spam and killed messages are in the junk folder (may take a while!)">&2
    notmuch search --output=files 'tag:killed OR tag:spam' | grep --color=never -v 'Maildir/.Junk' > /tmp/.inbox2archive #ALL things that are spam must go to spam folder
    if [ $? -eq 0 ] && [ -s /tmp/.inbox2archive ]; then
        cat /tmp/.inbox2archive | xargs mv -vt /home/proycon/Maildir/.Junk/cur/
    fi

    #undo the inbox tag for things that are killed or spam
    notmuch tag -inbox 'tag:inbox AND (tag:killed OR tag:spam)' 

    echo "Moving everything to archive that doesn't belong in inbox folder anymore (may take a while!)">&2
    notmuch search --output=files 'not tag:inbox' | grep --color=never 'Maildir/cur' > /tmp/.inbox2archive
    if [ $? -eq 0 ] && [ -s /tmp/.inbox2archive ]; then
        cat /tmp/.inbox2archive | xargs mv -vt /home/proycon/Maildir/.Archive/cur/
    fi
    rm /tmp/.inbox2archive

    echo "Done archiving, calling updatemail">&2
    updatemail.sh
fi
