#!/bin/sh
die() {
    echo "$@">&2
    exit 2
}
if [ -n "$1" ]; then
    BARPID=$1
else
    die "Pass bar pid..."
fi
while true; do
    inotifywait --monitor ~/.todo/timetrack.txt 2>&1 | while read -r line; do
        case $line in
            *MODIFY*)
                #send signal to parent
                kill -38 "$BARPID" || die "bar is dead"
                ;;
        esac
    done
    echo "inotifywait timetrack died....">&2
    sleep 1
done
die "timetrack wrapper died...."
