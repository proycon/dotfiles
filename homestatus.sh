#!/bin/bash


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


NOW=$(date +%s | tr -d '\n')
LASTUPDATE=$(stat -c %Y /tmp/homestatus/presence | tr -d '\n')
TIMEDELTA=$(( (NOW - LASTUPDATE) / 60 ))
echo -e  "${bold}Last update:${normal}   $TIMEDELTA mins ago"
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
cat /tmp/homestatus/temperature | sed 's/,/\n              /g'  2> /dev/null
echo -en "${bold}climate${normal}:       "
cat /tmp/homestatus/climate | sed 's/,/\n              /g' 2> /dev/null
echo -en "${bold}doors/windows${normal}: ${boldred}"
cat /tmp/homestatus/doors | sed 's/ /\n               /g' 2> /dev/null
echo -en $normal
echo -en "${bold}lights${normal}: ${boldyellow}       "
cat /tmp/homestatus/lights | sed 's/ /\n               /g' 2> /dev/null
echo -en $normal

