#!/bin/sh
while true; do
    inotifywait --monitor ~/.todo/timetrack.txt 2>&1 | while read -r line; do
        case $line in
            *MODIFY*)
                #send signal to parent
                kill -38 "$1"
                ;;
        esac
    done
    echo "inotifywait timetrack died....">&2
    sleep 1
done
echo "timetrack wrapper died....">&2
