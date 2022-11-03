#!/bin/sh

# Homestatus display, returns a report on the current
# cached status, can automatically update when the cache
# updates. Does NOT handle communication with the backend.

STATEDIR=/tmp/homestatus/

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
    green="\${color green}"
    magenta="\${color magenta}"
    yellow="\${color yellow}"
    boldred="\${color red}"
    boldgreen="\${color green}"
    boldyellow="\${color yellow}"
elif [ "$format" = "html" ]; then
    bold="<span style=\"font-weight: bold;\">"
    normal="</span>"
    yellow="<span style=\"color: yellow\">"
    green="<span style=\"color: green\">"
    boldred="<span style=\"font-weight: bold; color: red\">"
    boldgreen="<span style=\"font-weight: bold; color: green\">"
    boldyellow="<span style=\"font-weight: bold; color: yellow\">"
elif [ "$format" = "pango" ]; then
    bold="<span weight=\"bold\">"
    normal="</span>"
    magenta="<span foreground=\"#ff54ff\">"
    yellow="<span foreground=\"#ffff54\">"
    green="<span foreground=\"#54ff54\">"
    boldred="<span weight=\"bold\" foreground=\"#ff5454\">"
    boldgreen="<span weight=\"bold\" foreground=\"#54ff54\">"
    boldyellow="<span weight=\"bold\" foreground=\"#ffff54\">"
elif [ "$format" = "ansi" ]; then
    bold=$(tput bold)
    boldred=${bold}$(tput setaf 1) #  red
    boldgreen=${bold}$(tput setaf 2) #  green
    green=${normal}$(tput setaf 2) #  green
    yellow=${normal}$(tput setaf 3) #  yellow
    magenta=${normal}$(tput setaf 5) 
    #blue=${normal}$(tput setaf 4) #  blue
    #boldblue=${bold}$(tput setaf 4) #  blue
    boldyellow=${bold}$(tput setaf 3) #  yellow
    normal=$(tput sgr0)
else
    bold=""
    normal=""
    yellow=""
    magenta=""
    green=""
    boldred=""
    boldgreen=""
    boldyellow=""
fi


printstategroup() {
    label="$1"
    shift
    filenames="$*"
    grouplabel="$label:"
    color=
    for filename in $filenames; do 
        if [ -e "$STATEDIR/$filename" ]; then
            VALUE=$(cat "$STATEDIR/$filename")
            WITHTIMEDELTA=0
            case $label in 
                alarm)
                    TIMESTAMP=$(stat -c %Y "$STATEDIR/$filename" | tr -d '\n')
                    TIMEDELTA=$(( (NOW - TIMESTAMP) ))
                    WITHTIMEDELTA=1
                    case $VALUE in
                        triggered)
                            color="$boldred"
                            ;;
                        armed*)
                            color="$boldyellow"
                            ;;
                        *)
                            color="$boldgreen"
                            ;;
                    esac
                    ;;
                presence)
                    TIMESTAMP=$(stat -c %Y "$STATEDIR/$filename" | tr -d '\n')
                    TIMEDELTA=$(( (NOW - TIMESTAMP) ))
                    WITHTIMEDELTA=1
                    case $VALUE in
                        off|OFF)
                            color="$boldred"
                            VALUE="$(basename "$filename")"
                            ;;
                        on|ON)
                            color="$boldgreen"
                            VALUE="$(basename "$filename")"
                            ;;
                    esac
                    ;;
                lights)
                    case $VALUE in
                        off|OFF)
                            continue #don't show lights that are off
                            ;;
                        on|ON)
                            color="$boldyellow"
                            VALUE="$(basename "$filename")"
                            ;;
                    esac
                    ;;
                apertures)
                    case $VALUE in
                        off|OFF|unknown)
                            continue #don't show doors/windows that are closed
                            ;;
                        on|ON)
                            color="$magenta"
                            VALUE="$(basename "$filename" | sed "s/_sensor//" | sed "s/_/-/g")"
                            ;;
                    esac
                    ;;
            esac
            case $filename in
                *temperature*|*climate*)
                    unit=" °C"
                    case $filename in
                        *bedroom*)
                            extralabel=bedroom
                            ;;
                        *living*)
                            extralabel=living
                            ;;
                        *office*)
                            extralabel=office
                            ;;
                        *outside*)
                            extralabel=outside
                            ;;
                        *)
                            extralabel=""
                            ;;
                    esac
                    ;;
                *)
                    unit=""
                    ;;
            esac
            if [ -n "$color" ]; then
                colorend="$normal"
            else
                colorend=
            fi
            if [ $WITHTIMEDELTA -eq 1 ]; then
                extralabel=$(printtimedelta)
            fi
            if [ -n "$extralabel" ]; then
                printf "${bold}%-13s${normal} %s%s (%s)\n" "$grouplabel" "${color}$VALUE${colorend}" "$unit" "$extralabel"
            else
                printf "${bold}%-13s${normal} %s%s\n" "$grouplabel" "${color}$VALUE${colorend}" "$unit"
            fi
            grouplabel=""
        fi
    done
}


getlastupdate() {
    for filename in $1/*; do
        case $filename in 
            *trigger)
                continue #ignore
                ;;
        esac
        if [ -f "$filename" ]; then
            TIMESTAMP=$(stat -c %Y "$filename" | tr -d '\n')
            if [ $TIMESTAMP -gt $LASTUPDATE ]; then
                LASTUPDATE=$TIMESTAMP
            fi
        elif [ -d "$filename" ]; then
            #recurse
            getlastupdate "$filename"
        fi
    done
}

printtimedelta() {
    if [ $TIMEDELTA -lt 30 ]; then 
        echo -en  "${bold}${TIMEDELTA} s${normal}"
    elif [ $TIMEDELTA -lt 60 ]; then 
        echo -en  "${TIMEDELTA} s"
    else
        TIMEDELTA=$(( TIMEDELTA / 60 ))
        echo -en  "${TIMEDELTA} min"
    fi
}

printhomestatus() {
    NOW=$(date +%s | tr -d '\n')
    LASTUPDATE=0
    getlastupdate $STATEDIR
    TIMEDELTA=$(( (NOW - LASTUPDATE) ))

    if [ "$format" = "pango" ] && command -v sxmo_common.sh > /dev/null 2> /dev/null; then
        date +"<big><big><big><big><big><big><big><big><b>%H</b>:%M</big></big></big></big></big></big></big></big>:%S" #date with some pango markup syntax (https://docs.gtk.org/Pango/pango_markup.html)
        date +"%a %d %b %Y"
        echo "─────────────────────────────────"
    else
        echo "${bold}Time:         $(date +%H:%M:%S)${normal}"
    fi

    $HADIR

    if [ $TIMEDELTA -lt 120 ]; then 
        echo -en  "${bold}Last update:${normal}  ${green}$TIMEDELTA secs ago${normal} "
    else
        TIMEDELTA=$(( TIMEDELTA / 60 ))
        if [ $TIMEDELTA -lt 10 ]; then
            echo -en  "${bold}Last update:${normal}  ${yellow}$TIMEDELTA mins ago${normal}"
        else
            echo -en  "${bold}Last update:${normal}  ${red}$TIMEDELTA mins ago${normal}"
        fi
    fi
    if pgrep mosquitto_sub > /dev/null; then
        echo -e  " (${boldgreen}run${normal})"
    else
        echo -e  "(${boldred}OFF${normal})"
    fi
    if pgrep NetworkManager >/dev/null 2>/dev/null; then
        nmcli -w 3 -c no -p -f DEVICE,STATE,NAME,TYPE con show | grep activated | sed 's/activated/   /' | sed '/^\s*$/d' 2> /dev/null
    fi
    if command -v vnstat >/dev/null; then
    if ip a | grep -q wwan0; then
        #only if wwan0 exists
        vnstat wwan0 --oneline | cut -d ';' -f 11 2> /dev/null
    fi
    fi
    if [ "$1" = "html" ]; then
        echo "<hr/>"
    else
        echo "─────────────────────────────────"
    fi
    printstategroup "alarm" "alarm"
    printstategroup "presence" "presence/proycon" "presence/hans"
    printstategroup "temperature" "sensor/temperature_living_room" "sensor/bedroom_temperature"  "sensor/office_temperature" "sensor/outside_temperature"
    printstategroup "climate" "climate/cv"
    printstategroup "apertures" "binary_sensor/frontdoor" "binary_sensor/backdoor" "binary_sensor/bathroom_window_sensor" "binary_sensor/bedroomwindow_right" "binary_sensor/bedroomwindow_left"
    printstategroup "lights" "lights/tv_spots" "lights/front_room" "lights/midspots" "lights/back_room" "lights/back_corner" "lights/kitchen" "lights/hall" "lights/office" "lights/bedroom" "lights/balcony" "lights/garden" "lights/porch" "lights/roof"

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


#update when a file updates
#additionally we have an extra trigger file that cron can poke each minute to update the clock
if [ $loop -eq 1 ]; then
    echo "looping">&2
    touch /tmp/homestatus/trigger
	while true; do
        files=$(find /tmp/homestatus -type f)
        inotifywait -t 3 -e create,modify,attrib /tmp/homestatus $files /tmp/homestatus/trigger | printhomestatus
    done
else
    printhomestatus
fi

if [ -n "$finalkill" ]; then
    pkill -f $finalkill
fi

