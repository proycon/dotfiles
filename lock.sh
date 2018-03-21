#scrot -e 'convert -resize 20% -fill "#282828" -colorize 50% -blur 0x1 -resize 500% $f ~/lockbg.png'
if [[ ! -f /tmp/locked ]]; then
    touch /tmp/locked
    play ~/dotfiles/media/lock.wav >/dev/null 2>/dev/null &!
    #scrot -e "convert \$f -fill '#282828' -colorize 50% -scale 10% -scale 1000% ~/lockbg.png" "lockbg.png"
    #convert -gravity center -composite ~/lockbg.png ~/dotfiles/media/locked.png ~/lockfinal.png
    i3lock -c '#000000'
    #i3lock -e -b -i ~/lockfinal.png
    #rm ~/lockfinal.png ~/lockbg.png /tmp/locked
    rm /tmp/locked
fi
