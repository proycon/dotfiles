#!/bin/sh

. ~/dotfiles/scripts/colorargs.sh 

icon_chk="✔"
connections() {
	ACTIVE="$(nmcli -c no -t c show --active | cut -d: -f1,3 | sed "s/$/ $icon_chk/")"
	INACTIVE="$(nmcli -c no -t c show | cut -d: -f1,3)"
	printf %b "$ACTIVE\n$INACTIVE" | sort -u -t: -k1,1
}

toggleconnection() {
	CONNLINE="$1"
	CONNNAME="$(echo "$CHOICE" | cut -d: -f1)"
    if [ -n "$CONNNAME" ]; then
        if echo "$CONNLINE" | grep "$icon_chk"; then
            RES="$(nmcli c down "$CONNNAME" 2>&1)"
        else
            RES="$(nmcli c up "$CONNNAME" 2>&1)"
        fi
        notify-send "$RES"
    fi
}

scan() {
    ssid=$( nmcli -g ssid -c no device wifi | bemenu -p 'Networks' -l 20 --fn "$BEMENU_FONT" $BEMENU_COLORARGS)

    if [ -f ~/.password-store/"$ssid".gpg ]; then
        passwd=$(  pass show "$ssid" | head -n 1 )
    else
        passwd=$(bemenu -p 'Password' -l 20 --fn "$BEMENU_FONT" $BEMENU_COLORARGS)
    fi

    nmcli dev wifi connect "$ssid" password "$passwd"
}


CHOICE="$(
    printf %b "
        Scan
        $(connections)
        Close Menu
    " |
    awk '{$1=$1};1' | grep '\w' | bemenu -p 'Networks' -l 20 --fn "$BEMENU_FONT" $BEMENU_COLORARGS
)"
case "$CHOICE" in
    "Close Menu" )
        exit
        ;;
    "Scan")
        scan
        ;;
    *)
        toggleconnection "$CHOICE"
        ;;
esac

