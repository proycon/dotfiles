#scrot -e 'convert -resize 20% -fill "#282828" -colorize 50% -blur 0x1 -resize 500% $f ~/lockbg.png'
if [[ ! -f /tmp/locked ]]; then
    lasttask=$(tail -n 1 ~/.timetracker.log | cut --delimiter=" " -f 4 | tr -d '\n')
    ~/dotfiles/timetracker.sh 0 afk
    touch /tmp/locked
    play ~/dotfiles/media/lock.wav >/dev/null 2>/dev/null &!
    setxkbmap proylatin
    if [ -n "$WAYLAND_DISPLAY" ]; then
        swaylock -f -c 220000
    else
        i3lock -n -c '#220000'
    fi
    play ~/dotfiles/media/unlock.wav >/dev/null 2>/dev/null &!
    rm /tmp/locked
    ~/dotfiles/timetracker.sh 0 "$lasttask"
fi
