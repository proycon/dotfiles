#!/bin/sh

# Homestatus display, returns a report on the current
# cached status, can automatically update when the cache
# updates. Does NOT handle communication with the backend.

loop=0
format="ansi"
finalkill=""

while true; do
    case $1 in
        "conky")
            format=conky
            ;;
        "pango")
            format=pango
            ;;
        "no")
            format=""
            ;;
        "html")
            format=html
            ;;
        "ansi")
            format=html
            ;;
        "loop")
            loop=1
            ;;
        "wayout")
            finalkill=wayout
            ;;
        *)
            break
    esac
    shift
done

if [ "$format" = "conky" ]; then
    bold="\${color white}"
    normal="\${color white}"
    boldred="\${color red}"
    boldgreen="\${color green}"
    boldyellow="\${color yellow}"
elif [ "$format" = "html" ]; then
    bold="<span style=\"font-weight: bold;\">"
    normal="</span>"
    boldred="<span style=\"font-weight: bold; color: red\">"
    boldgreen="<span style=\"font-weight: bold; color: green\">"
    boldyellow="<span style=\"font-weight: bold; color: yellow\">"
elif [ "$format" = "pango" ]; then
    bold="<span weight=\"bold\">"
    normal="</span>"
    boldred="<span weight=\"bold\" foreground=\"red\">"
    boldgreen="<span weight=\"bold\" foreground=\"green\">"
    boldyellow="<span weight=\"bold\" foreground=\"yellow\">"
elif [ "$format" = "ansi" ]; then
    bold=$(tput bold)
    boldred=${bold}$(tput setaf 1) #  red
    boldgreen=${bold}$(tput setaf 2) #  green
    green=${normal}$(tput setaf 2) #  green
    yellow=${normal}$(tput setaf 3) #  yellow
    blue=${normal}$(tput setaf 4) #  blue
    boldblue=${bold}$(tput setaf 4) #  blue
    boldyellow=${bold}$(tput setaf 3) #  yellow
    normal=$(tput sgr0)
else
    bold=""
    normal=""
    boldred=""
    boldgreen=""
    boldyellow=""
fi


printhomestatus() {
    NOW=$(date +%s | tr -d '\n')
    LASTUPDATE=$(stat -c %Y /tmp/homestatus/lights | tr -d '\n')
    TIMEDELTA=$(( (NOW - LASTUPDATE) / 60 ))

    if [ "$format" = "pango" ] && command -v sxmo_common.sh > /dev/null 2> /dev/null; then
        date +"<big><big><big><big><big><big><big><big><b>%H</b>:%M</big></big></big></big></big></big></big></big>" #date with some pango markup syntax (https://docs.gtk.org/Pango/pango_markup.html)
        date +"%a %d %b %Y"
        echo "─────────────────────────────────"
    else
        echo -e  "${bold}Time:          $(date +%H:%M)${normal}"
    fi


    echo -en  "${bold}Last update:${normal}   $TIMEDELTA mins ago "
    if pgrep mosq > /dev/null; then
        echo -e  "(${boldgreen}ok${normal})"
    else
        echo -e  "(${boldred}no daemon${normal})"
    fi
    nmcli -w 3 -c no -p -f DEVICE,STATE,NAME,TYPE con show | grep activated | sed 's/activated/   /' | sed '/^\s*$/d' 2> /dev/null
    vnstat wwan0 --oneline | cut -d ';' -f 11 2> /dev/null
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

    if command -v sxmo_common.sh > /dev/null 2> /dev/null; then
        cannot_suspend_reasons="$(sxmo_mutex.sh can_suspend list)"
        if [ "$format" = "pango" ] && [ -n "$cannot_suspend_reasons" ]; then
            echo "<small><small><small><small>"
            printf "%s" "$cannot_suspend_reasons" | awk '{print "• " $0}'
            echo "</small></small></small></small>"
        fi
    fi
    echo -e "\n"
}


#lights is the last status message, so we only watch that, as they always come in batches
#additionally we have an extra trigger file that cron can poke each minute to update the clock
if [ $loop -eq 1 ]; then
    echo "looping">&2
    touch /tmp/homestatus/trigger
    [ ! -f /tmp/homestatus/lights ] && touch /tmp/homestatus/lights
	while true; do
        inotifywait -e create,modify,attrib /tmp/homestatus/lights /tmp/homestatus/trigger | printhomestatus
    done
else
    printhomestatus
fi

if [ -n "$finalkill" ]; then
    pkill -f $finalkill
fi

