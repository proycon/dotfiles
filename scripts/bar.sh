#!/bin/sh
sec=0
proc_num=$(nproc)

update_time () {
    local icon=""
    case "$(date +'%I')" in
        01) icon="󱐿" ;;
        02) icon="󱑀" ;;
        03) icon="󱑁" ;;
        04) icon="󱑂" ;;
        05) icon="󱑃" ;;
        06) icon="󱑄" ;;
        07) icon="󱑅" ;;
        08) icon="󱑆" ;;
        09) icon="󱑇" ;;
        10) icon="󱑈" ;;
        11) icon="󱑉" ;;
        12) icon="󱑊" ;;
    esac
    time="$icon $(date '+%H:%M')"
}

update_bluetooth() {
    local icon="󰂯"
    if ! pgrep -x 'bluetoothd' >/dev/null; then
        icon="󰂲"
    else
        local level="$(bluetoothctl info | grep -m1 'Battery Percentage' | awk -F'[()]' '{print $2}')"
        [ -n "$level" ] && icon="󰂱" level="${level}%"
    fi
    bluetooth="${icon}${level}"
}

update_volume() {
    local text=$(amixer get Master | tail -1)
    local status=$(echo $text | grep -oE '\[on\]|\[off\]')
    local level=$(echo $text | grep -oE '[0-9]+%')
    [ "$status" = "[on]" ] && icon=" " || icon=" "
    volume="${icon}${level}"
}

update_microphone() {
    local text=$(amixer get Capture | tail -1)
    local status=$(echo $text | grep -oE '\[on\]|\[off\]')
    local level=$(echo $text | grep -oE '[0-9]+%')
    [ "$status" = "[on]" ] && icon="" || icon=""
    microphone="${icon}${level}"
}

update_brightness() {
    local icon=""
    local level="$(( $(brightnessctl g) * 100 / $(brightnessctl m) ))"
    case $level in
        [0-9]) icon="󱩎 " ;;
        1[0-9]) icon="󱩏 " ;;
        2[0-9]) icon="󱩐 " ;;
        3[0-9]) icon="󱩐 " ;;
        4[0-9]) icon="󱩑 " ;;
        5[0-9]) icon="󱩒 " ;;
        6[0-9]) icon="󱩓 " ;;
        7[0-9]) icon="󱩔 " ;;
        8[0-9]) icon="󱩕 " ;;
        9[0-9]) icon="󱩖 " ;;
        100%)     icon="󰛨 "  ;;
    esac
    [ -z "$level" ] || level="${level}%"
    brightness="${icon}${level}"
}

update_battery () {
    local icon=""
    local POWER="/sys/class/power_supply"
    local status="$(cat $POWER/BAT?/status)"
    local level="$(cat $POWER/BAT?/capacity)"
    case "$status" in
        "Discharging")
            case "$level" in
                [0-5]) icon="^#ff0000FF󰂎^#!";;
                [6-9]) icon="^#ff0000FF󰁺^#!";;
                1[0-9]) icon="^#ff9c00FF󰁻^#!";;
                2[0-9]) icon="󰁼";;
                3[0-9]) icon="󰁽";;
                4[0-9]) icon="󰁽";;
                5[0-9]) icon="󰁾";;
                6[0-9]) icon="󰁿";;
                7[0-9]) icon="󰂀";;
                8[0-9]) icon="󰂁";;
                9[0-9]) icon="󰂂";;
                100)    icon="^#00ff00FF󰁹^#!";;
            esac
            level="${level}%"
            ;;
        "Not charging")
            icon="" level="${level}%"
            ;;
        "Charging")
            icon="" level="${level}%"
            ;;
    esac
    ls ${POWER}/BAT? > /dev/null || icon=""
    battery="${icon}${level}"
}

update_ethernet() {
    local status="$(cat /sys/class/net/e*/operstate 2>/dev/null)"
    local icon="󰛳 "
    [ "$status" != "up" ] && icon="󰲛 "
    ethernet="$icon"
}

update_wifi() {
    local status="$(cat /sys/class/net/wlan*/operstate 2>/dev/null)"
    local level="$(awk '/^\s*w/ {print int($3 * 100 / 70)"%"}' /proc/net/wireless)"
    [ "$status" = "up" ] && icon="󰖩 " || icon="^#ff0000FF󰖪 ^#!" level=""
    wifi="${icon}${level}"
}

update_temperature() {
    local icon=""
    local THERMEL="/sys/class/thermal/thermal_zone0/temp"
    local value="$(sed 's/000$//' "$THERMEL")"
    [ -z "$value" ] && icon="󱔱" temperature=""
    case "$value" in
        [0-3][0-9]) icon="" ;;
        4[0-9]) icon="" ;;
        [5-6][0-9]) icon="" ;;
        [7-9][0-9]) icon="" ;;
    esac
    [ -z "$value" ] || value="${value}℃"
    temperature="${icon}${value}"
}

update_cpu() {
    local usage="$(( $(awk '{ printf "%.0f", $1*100 }' /proc/loadavg) / $proc_num ))"
    local icon=" "
    [ -z "$usage" ] || usage="${usage}%"
    cpu="${icon}${usage}"
}

update_memory() {
    local usage="$(free | awk 'NR==2 {printf "%.0f%%(%.1fG)\n", $3/$2 * 100, $3/1024/1024}')"
    local icon=" "
    memory="${icon}${usage}"
}

update_keyboard() {
    if [ -e "$XDG_RUNTIME_DIR/rivermap.state" ]; then
        keyboard=" $(cat "$XDG_RUNTIME_DIR/rivermap.state" | sed 's/ (Proycon)//g' | sed 's/Universal //g')"
    else
        keyboard="^#ff0000FF^#!"
    fi
}

update_task() {
    task=$(todo.sh timetrack current -d | sed 's/&/&amp;/g' | awk '{print substr($0, 0, 40)}')
}

update_volume;update_time
#update_microphone; update_brightness

trap	"update_volume;display"	  	"RTMIN"   # -34 .local/bin/audio
trap	"update_microphone;display"	"RTMIN+1"   # -35 .local/bin/audio
trap	"update_brightness;display"	"RTMIN+2"   # -36 .local/bin/bright
trap	"update_keyboard;display"   "RTMIN+3"   # -37

display () {
    local space=" "         # ` `(U+2009) is the Thin Space
    local delimiter_color="^#EED49FFF"
    local delimiter_home="$delimiter_color[^#!"
    local delimiter_end="$delimiter_color]^#!"
    local separator="$delimiter_color][^#!"
    #printf "%s" "${delimiter_home}${memory}${space}${cpu}${space}${temperature}${separator}${wifi}${space}${ethernet}${separator}${brightness}${space}${microphone}${space}${volume}${separator}${battery}${space}${bluetooth}${separator}${time}${delimiter_end}"
    printf "%s\n" "(${task}...)${space}${keyboard}${space}${cpu}${space}${wifi}${space}${volume}${space}${battery}${space}${time}"
}

MAINPID=$$
(rivermap -d | while read -r line; do
    #write to temporary file (memory-backed fs)
    echo "$line"  > "$XDG_RUNTIME_DIR/rivermap.state"
    #send signal to parent
    kill -37 "$MAINPID"
done) &

while true
do
    # to update item ever n seconds with a offset of m
    {
        ## [ $((sec % n)) -eq m ] && udpate_item
        [ $((sec % 10 )) -eq 0 ] && update_task 	# update task every 10 seconds
        [ $((sec % 10 )) -eq 0 ] && update_keyboard 	# update task every 10 seconds
        [ $((sec % 60 )) -eq 0 ] && update_volume 	# update volume every minute
        [ $((sec % 10 )) -eq 0 ] && update_time 	# update time every 10 seconds
        if [ "$HOSTNAME" != "pollux" ]; then
            [ $((sec % 10)) -eq 0 ] && update_wifi
            [ $((sec % 10)) -eq 0 ] && update_battery
            #[ $((sec % 10)) -eq 0 ] && update_bluetooth
            [ $((sec % 10)) -eq 0 ] && update_ethernet
        fi
        #[ $((sec % 5)) -eq 0 ] && update_temperature
        [ $((sec % 5)) -eq 0 ] && update_cpu
        #[ $((sec % 5)) -eq 0 ] && update_memory

        # how often the display updates ( 5 seconds )
        [ $((sec % 5 )) -eq 0 ] && display

        sec=$((sec + 1))
    }
    sleep 1 & wait
done
