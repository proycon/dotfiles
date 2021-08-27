icon_chk="✔"
connections() {
	ACTIVE="$(nmcli -c no -t c show --active | cut -d: -f1,3 | sed "s/$/ $icon_chk/")"
	INACTIVE="$(nmcli -c no -t c show | cut -d: -f1,3)"
	printf %b "$ACTIVE\n$INACTIVE" | sort -u -t: -k1,1
}

toggleconnection() {
	CONNLINE="$1"
	CONNNAME="$(echo "$CHOICE" | cut -d: -f1)"
	if echo "$CONNLINE" | grep "$icon_chk"; then
		RES="$(nmcli c down "$CONNNAME" 2>&1)"
	else
		RES="$(nmcli c up "$CONNNAME" 2>&1)"
	fi
	notify-send "$RES"
}

CHOICE="$(
    printf %b "
        $(connections)
        Close Menu
    " |
    awk '{$1=$1};1' | grep '\w' | bemenu -p 'Networks' -l 20 --fn "Monospace 16"
)"
case "$CHOICE" in
    "Close Menu" )
        exit
        ;;
    *)
        toggleconnection "$CHOICE"
        ;;
esac
