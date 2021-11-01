#!/bin/bash

loop=0

if [ "$1" = "conky" ]; then
    bold="\${color white}"
    normal="\${color white}"
    boldred="\${color red}"
    boldgreen="\${color green}"
    boldyellow="\${color yellow}"
elif [ "$1" = "no" ]; then
    bold=""
    normal=""
    boldred=""
    boldgreen=""
    boldyellow=""
elif [ "$1" = "html" ]; then
    bold="<span style=\"font-weight: bold;\">"
    normal="</span>"
    boldred="<span style=\"font-weight: bold; color: red\">"
    boldgreen="<span style=\"font-weight: bold; color: green\">"
    boldyellow="<span style=\"font-weight: bold; color: yellow\">"
elif [ "$1" = "pango" ]; then
    bold="<span weight=\"bold\">"
    normal="</span>"
    boldred="<span weight=\"bold\" foreground=\"red\">"
    boldgreen="<span weight=\"bold\" foreground=\"green\">"
    boldyellow="<span weight=\"bold\" foreground=\"yellow\">"
else
    bold=$(tput bold)
    boldred=${bold}$(tput setaf 1) #  red
    boldgreen=${bold}$(tput setaf 2) #  green
    green=${normal}$(tput setaf 2) #  green
    yellow=${normal}$(tput setaf 3) #  yellow
    blue=${normal}$(tput setaf 4) #  blue
    boldblue=${bold}$(tput setaf 4) #  blue
    boldyellow=${bold}$(tput setaf 3) #  yellow
    normal=$(tput sgr0)
fi

if [ "$1" = "loop" ] || [ "$2" = "loop" ]; then
    echo "looping">&2
    loop=1
fi

forceupdate() {
    WAIT=0
}

trap 'forceupdate' USR1 USR2

while [ 1 ]; do
    NOW=$(date +%s | tr -d '\n')
    LASTUPDATE=$(stat -c %Y /tmp/homestatus/presence | tr -d '\n')
    TIMEDELTA=$(( (NOW - LASTUPDATE) / 60 ))
    echo -e  "${bold}Time:          $(date +%H:%M)${normal}"
    echo -en  "${bold}Last update:${normal}   $TIMEDELTA mins ago "
    if pgrep mosq > /dev/null; then
        echo -e  "(${boldgreen}ok${normal})"
    else
        echo -e  "(${boldred}no daemon${normal})"
    fi
    nmcli -w 3 -c no -p -f DEVICE,STATE,NAME,TYPE con show | grep activated | sed 's/activated/   /' | sed '/^\s*$/d' 2> /dev/null
    if [ "$1" = "html" ]; then
        echo "<hr/>"
    else
        echo "─────────────────────────────────"
    fi
    echo -en "${bold}presence${normal}: ${boldgreen}     "
    cat /tmp/homestatus/presence 2> /dev/null
    echo -en $normal
    echo -en "${bold}alarm${normal}:         "
    cat /tmp/homestatus/alarm 2> /dev/null
    echo -en "${bold}temperature${normal}:   "
    cat /tmp/homestatus/temperature | sed 's/,/\n              /g' | sed '/^\s*$/d' 2> /dev/null
    echo -en "${bold}climate${normal}:       "
    cat /tmp/homestatus/climate | sed 's/,/\n              /g' | sed '/^\s*$/d' 2> /dev/null
    echo -en "${bold}doors/windows${normal}: ${boldred}"
    cat /tmp/homestatus/doors | sed 's/ /\n               /g' | sed '/^\s*$/d' 2> /dev/null
    echo -en $normal
    echo -en "${bold}lights${normal}: ${boldyellow}       "
    cat /tmp/homestatus/lights | sed 's/ /\n               /g' | sed '/^\s*$/d' 2> /dev/null
    echo -en $normal
    if [ $loop -eq 1 ]; then
        echo -e "\n"
        SECS=$(date +%S)
        #sleep until next minute
        WAIT=$((60 - SECS - 1))
        while [ $WAIT -gt 0 ] ; do
            WAIT=$((WAIT - 1))
            sleep 1
        done
        ./dotfiles/homecommand.sh status &
    else
        break
    fi
done

