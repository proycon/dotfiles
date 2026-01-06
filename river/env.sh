#!/bin/sh

_find_runtime_dir() {
    #(copied from sxmo)

	# Take what we gave to you
	if [ -n "$XDG_RUNTIME_DIR" ]; then
		printf %s "$XDG_RUNTIME_DIR"
		return
	fi

	# Try something existing
	for root in /run /var/run; do
		path="$root/user/$(id -u)"
		if [ -d "$path" ] && [ -w "$path" ]; then
			printf %s "$path"
			return
		fi
	done

	if command -v mkrundir > /dev/null 2>&1; then
		mkrundir
		return
	fi

	# Fallback to a shared memory location
    _RDIR="/dev/shm/user/$(id -u)"
    mkdir -p "$_RDIR"
	echo "$_RDIR"
}

export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORM="wayland;xcb"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_SCALE_FACTOR=1.8
#export TDESKTOP_DISABLE_GTK_INTEGRATION=1
export CLUTTER_BACKEND=wayland
export ELM_SCALE=1.8
export XDG_CURRENT_DESKTOP=river
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=river
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export SDL_VIDEODRIVER=wayland
export GLFW_IM_MODULE=fcitx
#export GTK_IM_MODULE=fcitx
export INPUT_METHOD=fcitx
export XMODIFIERS=@im=fcitx
export IMSETTINGS_MODULE=fcitx
export QT_IM_MODULE=fcitx
#export GDK_DPI_SCALE=2    # only needed for firefox, messes up others
export BEMENU_BACKEND=wayland
FG="#bbbbbb"
BG="#222222"
FGSEL="#eeeeee"
BGSEL="#005577"
export BEMENU_OPTS="--fn 'Monospace 32' --nb $BG --nf $FG --sb $BGSEL --sf $FGSEL"
export SXMO_MENU=wofi

if [ -z "$XDG_RUNTIME_DIR" ]; then
    XDG_RUNTIME_DIR="$(_find_runtime_dir)"
    export XDG_RUNTIME_DIR
fi
export PATH="/home/proycon/bin:/home/proycon/.cargo/bin:/home/proycon/local/bin:$PATH"
export MPD_HOST="anaproy.nl"
export DEBEMAIL="proycon@anaproy.nl"
export DEBFULLNAME="Maarten van Gompel"
export TODO_DIR="$HOME/Server/.todo"
#export GTK_THEME=Adwaita-dark
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export PINENTRY_USER_DATA=wayprompt
. ~/dotfiles/scripts/gpgsetup.sh
. ~/dotfiles/user-dirs.dirs
export XDG_DESKTOP_DIR XDG_DOCUMENTS_DIR XDG_PICTURES_DIR XDG_MUSIC_DIR XDG_DOWNLOAD_DIR XDG_VIDEOS_DIR

HOSTNAME=$(hostname)
if [ "$HOSTNAME" = "trantor" ] || [ "$HOSTNAME" = "toren" ]; then
    KB_OPTS="-options lv3:ralt_switch,caps:ctrl_modifier,altwin:swap_lalt_lwin,compose:rctrl"
else
    KB_OPTS=
fi
export KB_OPTS

