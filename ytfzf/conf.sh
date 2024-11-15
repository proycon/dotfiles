

external_menu () {
    . ~/dotfiles/scripts/colorargs.sh
    #use rofi instead of dmenu
    bemenu -l 10 --fn "$BEMENU_FONT" -p "$1"
}
