#!/bin/sh
# configversion: 08c5e6ee96cf9f971c30c63eabf8efb7
# SPDX-License-Identifier: AGPL-3.0-only
# Copyright 2022 Sxmo Contributors

# This script will output the content of the contextual menu
# It should stdout the title as the first line followed by the entries

# include common definitions
# shellcheck source=scripts/core/sxmo_common.sh
. sxmo_common.sh
# shellcheck source=configs/default_hooks/sxmo_hook_icons.sh
. sxmo_hook_icons.sh

XPROPOUT="$(sxmo_wm.sh focusedwindow)"
WMCLASS="${1:-$(printf %s "$XPROPOUT" | grep app: | cut -d" " -f2- | tr '[:upper:]' '[:lower:]')}"

superd_service_isrunning() {
	superctl status "$1" | grep -q started
}

sxmo_service_isrunning() {
	sxmo_jobs.sh running "$1" > /dev/null
}

if [ -z "$XPROPOUT" ]; then
	sxmo_log "detected no active window, no problem, opening system menu"
else
	sxmo_log "opening menu for wmclass $WMCLASS"
fi

case "$WMCLASS" in
	scripts)
		# Scripts menu
		CHOICES="$(sxmo_hook_scripts.sh)"
		WINNAME=Scripts
		;;
	applications)
		# Apps menu
		CHOICES="$(sxmo_hook_apps.sh)"
		WINNAME=Apps
		;;
	modem)
		# modem related
		CHOICES="
			$icon_plk Modem PIN                ^ 0 ^ sxmo_unlocksim.sh
			$icon_phn Modem Monitor $(
				superd_service_isrunning sxmo_modemmonitor &&
				printf %b "$icon_ton ^ 1 ^ superctl stop sxmo_modemmonitor" ||
				printf %b "$icon_tof ^ 1 ^ superctl start sxmo_modemmonitor"
			) && sxmo_hook_statusbar.sh modem_monitor
			$icon_wrh Restart System Daemons     ^ 1 ^ sxmo_hook_restart_modem_daemons.sh && sxmo_hook_statusbar.sh modem
			$icon_inf Modem Info                 ^ 0 ^ sxmo_modeminfo.sh
			$icon_phl Modem Log                  ^ 0 ^ sxmo_modemlog.sh
			$icon_img Config MMS                 ^ 1 ^ sxmo_mmsdconfig.sh
			$icon_img Config VVM                 ^ 1 ^ sxmo_vvmdconfig.sh
		"
		WINNAME=Modem
		;;
	config)
		# System Control menu
		CHOICES="
			$icon_aru Brightness               ^ 1 ^ sxmo_brightness.sh up
			$icon_ard Brightness               ^ 1 ^ sxmo_brightness.sh down
			$icon_cfg Touch $(
				sxmo_wm.sh inputevent touchscreen | grep -q on && \
				printf %b "$icon_ton ^ 1 ^ sxmo_wm.sh inputevent touchscreen off" || \
				printf %b "$icon_tof ^ 1 ^ sxmo_wm.sh inputevent touchscreen on"
			)
			$icon_cfg Stylus $(
				sxmo_wm.sh inputevent stylus | grep -q on && \
				printf %b "$icon_ton ^ 1 ^ sxmo_wm.sh inputevent stylus off" || \
				printf %b "$icon_tof ^ 1 ^ sxmo_wm.sh inputevent stylus on"
			)
			$icon_cfg Gestures $(
				superd_service_isrunning "sxmo_hook_lisgd" &&
				printf "%s" "$icon_ton" || printf "%s" "$icon_tof"
			) ^ 1 ^ supertoggle_daemon 'sxmo_hook_lisgd' && (rm $XDG_CACHE_HOME/sxmo/sxmo.nogesture 2>/dev/null || touch $XDG_CACHE_HOME/sxmo/sxmo.nogesture)
			$icon_cfg Toggle Bar ^ 0 ^ sxmo_wm.sh togglebar
			$icon_bth Bluetooth $(
				rfkill list bluetooth -no ID,SOFT,HARD | grep -vq " blocked" &&
				printf %b "$icon_ton" ||  printf %b "$icon_tof";
				printf %b "^ 1 ^ doas sxmo_bluetoothtoggle.sh && sxmo_hook_statusbar.sh bluetooth"
			)
			$(test "$SXMO_WM" = dwm && printf %b "$icon_cfg Invert Colors ^ 1 ^ xcalib -a -invert")
			$icon_clk Change Timezone            ^ 1 ^ sxmo_timezonechange.sh
			$icon_zzz Auto-suspend $(
				[ -e "$XDG_CACHE_HOME"/sxmo/sxmo.nosuspend ] && printf "%s" "$icon_tof" || printf "%s" "$icon_ton"
			) ^ 1 ^ (rm $XDG_CACHE_HOME/sxmo/sxmo.nosuspend 2>/dev/null || touch $XDG_CACHE_HOME/sxmo/sxmo.nosuspend)
			$icon_zzz Auto-screen-off $(
				[ -e "$XDG_CACHE_HOME/sxmo/sxmo.noidle" ] && printf "%s" "$icon_tof" || printf "%s" "$icon_ton"
			) ^ 1 ^ (rm $XDG_CACHE_HOME/sxmo/sxmo.noidle 2>/dev/null || touch $XDG_CACHE_HOME/sxmo/sxmo.noidle) && sxmo_state.sh set unlock
			$icon_ror Autorotate $(
				sxmo_jobs.sh running autorotate -q &&
				printf "%s" "$icon_ton" || printf "%s" "$icon_tof"
			) ^ 1 ^ toggle_daemon 'Autorotate' autorotate sxmo_autorotate.sh
			$([ -n "$SXMO_KEYBOARD_SLIDER_EVENT_DEVICE" ] && echo "$icon_ror Autorotate on Keyboard Open/Close $(
				sxmo_jobs.sh running kb_autorotate -q &&
				printf "%s" "$icon_ton" || printf "%s" "$icon_tof"
			) ^ 1 ^ toggle_daemon 'Keyboard Autorotate' kb_autorotate sxmo_keyboard_autorotate.sh")
			$icon_ror Rotate                     ^ 1 ^ sxmo_rotate.sh rotate
			$icon_trm Hooks                      ^ 0 ^ sxmo_hookmenu.sh
			$icon_upc Upgrade Pkgs               ^ 0 ^ sxmo_terminal.sh sxmo_upgrade.sh
			$icon_sfl Migrate configuration      ^ 0 ^ sxmo_terminal.sh sxmo_migrate.sh
			$icon_cfg Edit configuration         ^ 0 ^ sxmo_terminal.sh $EDITOR $XDG_CONFIG_HOME/sxmo/$(test "$SXMO_WM" = sway && printf sway || printf xinit)
			$(command -v pmos-tweaks >/dev/null && echo "$icon_cfg PostmarketOS Tweaks	     ^ 0 ^ GDK_SCALE=1 pmos-tweaks")
			$icon_cfg Suspend Blockers           ^ 0 ^ sxmo_terminal.sh sxmo_debug_suspend.sh
			$icon_inf Log                        ^ 0 ^ sxmo_terminal.sh tail -n 100 -f ${XDG_STATE_HOME:-$HOME}/sxmo.log
			$icon_inf Version                    ^ 0 ^ sxmo_terminal.sh sxmo_version.sh --block
		"
		WINNAME=Config
		;;
	power)
		# Power menu
		CHOICES="
			$icon_lck Lock               ^ 0 ^ sxmo_state.sh set lock
			$icon_lck Lock (Screen off)  ^ 0 ^ sxmo_state.sh set screenoff
			$icon_out Logout             ^ 0 ^ confirm Logout && sxmo_power.sh logout
			$([ -f "$(xdg_data_path xsessions/sxmo.desktop)" ] &&
				[ -f "$(xdg_data_path wayland-sessions/swmo.desktop)" ] &&
				echo "$icon_rol Toggle WM ^ 0 ^ confirm Toggle && sxmo_power.sh togglewm"
			)
			$icon_rld Reboot             ^ 0 ^ confirm Reboot && sxmo_power.sh reboot
			$icon_pwr Poweroff           ^ 0 ^ confirm Poweroff && sxmo_power.sh poweroff
		"
		WINNAME=Power
		;;
	*mpv*)
		# MPV
		CHOICES="
			$icon_pau Pause        ^ 0 ^ sxmo_type -k Space
			$icon_fbw Seek       ^ 1 ^ sxmo_type -k Left
			$icon_ffw Seek       ^ 1 ^ sxmo_type -k Right
			$icon_aru App Volume Up ^ 1 ^ sxmo_type 0
			$icon_ard App Volume Down ^ 1 ^ sxmo_type 9
			$icon_aru Speed up      ^ 1 ^ sxmo_type -k bracketRight
			$icon_ard Speed down    ^ 1 ^ sxmo_type -k bracketLeft
			$icon_cam Screenshot   ^ 1 ^ sxmo_type s
			$icon_itm Loopmark     ^ 1 ^ sxmo_type l
			$icon_inf Info         ^ 1 ^ sxmo_type i
			$icon_inf Seek Info    ^ 1 ^ sxmo_type o
		"
		WINNAME=Mpv
		;;
	io.bassi.amberol)
		CHOICES="
			$icon_pau Play/Pause ^ 0 ^ playerctl play-pause
			$icon_prv Previous Track ^ 1 ^ playerctl previous
			$icon_nxt Next Track ^ 1 ^ playerctl next
		"
		WINNAME=Amberol
		;;
	*feh*)
		# Feh
		CHOICES="
			$icon_arr Next          ^ 1 ^ sxmo_type -k Space
			$icon_arl Previous      ^ 1 ^ sxmo_type -k BackSpace
			$icon_zmi Zoom in       ^ 1 ^ sxmo_type -k up
			$icon_zmo Zoom out      ^ 1 ^ sxmo_type -k down
			$icon_exp Zoom to fit   ^ 1 ^ sxmo_type -k slash
			$icon_shr Zoom to fill  ^ 1 ^ sxmo_type '!'
			$icon_rol Rotate        ^ 1 ^ sxmo_type -k less
			$icon_ror Rotate        ^ 1 ^ sxmo_type -k greater
			$icon_a2y Flip          ^ 1 ^ sxmo_type -k underscore
			$icon_a2x Mirror        ^ 1 ^ sxmo_type -k bar
			$icon_inf Toggle filename ^ 1 ^ sxmo_type d
		"
		WINNAME=Feh
		;;
	*sxiv*)
		# Sxiv
		CHOICES="
			$icon_arr Next          ^ 1 ^ sxmo_type -k Space
			$icon_arl Previous      ^ 1 ^ sxmo_type -k BackSpace
			$icon_zmi Zoom in       ^ 1 ^ sxmo_type -k equal
			$icon_zmo Zoom out      ^ 1 ^ sxmo_type -k minus
			$icon_rol Rotate        ^ 1 ^ sxmo_type -k less
			$icon_ror Rotate        ^ 1 ^ sxmo_type -k greater
			$icon_a2y Flip          ^ 1 ^ sxmo_type -k question
			$icon_a2x Mirror        ^ 1 ^ sxmo_type -k bar
			$icon_grd Thumbnail     ^ 0 ^ sxmo_type -k Return
		"
		WINNAME=Sxiv
		;;
	*imv*)
		# imv
		CHOICES="
			$icon_arr Next          ^ 1 ^ sxmo_type -k Right
			$icon_arl Previous      ^ 1 ^ sxmo_type -k Left
			$icon_zmi Zoom in       ^ 1 ^ sxmo_type -k i
			$icon_zmo Zoom out      ^ 1 ^ sxmo_type -k minus
			$icon_exp Zoom to fit   ^ 1 ^ sxmo_type -k r
			$icon_ror Rotate        ^ 1 ^ sxmo_type -M ctrl r
			$icon_inf Toggle filename ^ 1 ^ sxmo_type -k d
		"
		WINNAME=Imv
		;;
	*gst-launch*)
		# gst launcher
		CHOICES="
			$icon_arr Screenshot    ^ 1 ^ sxmo_screenshot.sh
			$icon_arl Quit          ^ 1 ^ sxmo_type -M win -M shift Q
		"
		WINNAME=Gstreamer
		;;
	*kasts*)
		CHOICES="
			$icon_mus Audio ^ 0 ^ sxmo_audio.sh
			$icon_bth Bluetooth ^ 0 ^ sxmo_bluetoothmenu.sh
			"
		WINNAME="Kasts"
		;;
	*sthotkeys*)
		#  St hotkeys
		CHOICES="
			Send Ctrl-C      ^ 0 ^ sxmo_type -M Ctrl -k c
			Send Ctrl-Z      ^ 0 ^ sxmo_type -M Ctrl -k z
			Send Ctrl-L      ^ 0 ^ sxmo_type -M Ctrl -k l
			Send Ctrl-D      ^ 0 ^ sxmo_type -M Ctrl -k d
			Send Ctrl-A      ^ 0 ^ sxmo_type -M Ctrl -k a
			Send Ctrl-B      ^ 0 ^ sxmo_type -M Ctrl -k b
			Send ESC:w       ^ 0 ^ sxmo_type -k Escape -s 300 -M Shift -k semicolon -m Shift -k w -k Return
			Send ESC:wq      ^ 0 ^ sxmo_type -k Escape -s 300 -M Shift -k semicolon -m Shift -k w -k q -k Return
			Send ESC:wq!     ^ 0 ^ sxmo_type -k Escape -s 300 -M Shift -k semicolon -m Shift -k q -k exclam -k Return
		"
		WINNAME=St
		;;
	*foot*|*st*|*terminal*|org.gnome.vte.application|*alacritty*)
		WMNAME="${1:-$(printf %s "$XPROPOUT" | grep title: | cut -d" " -f2- | tr '[:upper:]' '[:lower:]')}"

		# These git commands only launch the editor.
		case "$WMNAME" in
			*"git add"*|*"git bugreport"*|*"git commit"*|*"git merge"*|*"git notes"*|*"git rebase"*|*"git replace"*|*"git send-email"*|*"git svn"*)
				WMNAME="$WMCLASS $EDITOR"
				;;
		esac

		# First we try to handle the app running inside the terminal:
		case " $WMNAME " in
		*" vi "*|*" vim "*|*" vis "*|*" nvim "*|*neovim*|*kakoune*)
			#Vim in foot
			CHOICES="
				$icon_cls Save and Quit    ^ 0 ^ sxmo_type -k Escape -s 300 ':wq' -k Return
				$icon_sav Save             ^ 0 ^ sxmo_type -k Escape -s 300 ':w' -k Return
				$icon_cls Quit without saving  ^ 0 ^ sxmo_type -k Escape -s 300 ':q!' -k Return
				$icon_aru Scroll up        ^ 1 ^ sxmo_type -M Ctrl u
				$icon_ard Scroll down      ^ 1 ^ sxmo_type -M Ctrl d
				$icon_trm Command prompt   ^ 0 ^ sxmo_type -k Escape -s 300 ':'
				$icon_pst Paste Selection  ^ 0 ^ sxmo_type -k Escape -s 300 -k quotedbl -k asterisk -k p
				$icon_pst Paste Clipboard  ^ 0 ^ sxmo_type -k Escape -s 300 -k quotedbl -k plus -k p
				$icon_fnd Search           ^ 0 ^ sxmo_type -k Escape -s 300 /
				$icon_arr Next buffer      ^ 1 ^ sxmo_type -k Escape -s 300 ':bn' -k Return
				$icon_arl Previous buffer  ^ 1 ^ sxmo_type -k Escape -s 300 ':bp' -k Return
				$icon_zmi Zoom in          ^ 1 ^ sxmo_type -k Prior
				$icon_zmo Zoom out         ^ 1 ^ sxmo_type -k Next
				$icon_mnu Terminal menu    ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=Vim
			;;
		*nano*)
			#Nano in foot
			CHOICES="
				$icon_aru Scroll up       ^ 1 ^ sxmo_type -k Prior
				$icon_ard Scroll down     ^ 1 ^ sxmo_type -k Next
				$icon_sav Save            ^ 0 ^ sxmo_type -M Ctrl o
				$icon_cls Quit            ^ 0 ^ sxmo_type -M Ctrl x
				$icon_pst Paste           ^ 0 ^ sxmo_type -M Ctrl u
				$icon_itm Type complete   ^ 0 ^ sxmo_type -M Shift -M Ctrl u
				$icon_cpy Copy complete   ^ 0 ^ sxmo_type -M Shift -M Ctrl i
				$icon_zmi Zoom in         ^ 1 ^ sxmo_type -k Prior
				$icon_zmo Zoom out        ^ 1 ^ sxmo_type -k Next
				$icon_mnu Terminal menu   ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=Nano
			;;
		*micro*)
			#Micro
			CHOICES="
				$icon_aru Scroll up       ^ 1 ^ sxmo_type -k Prior
				$icon_ard Scroll down     ^ 1 ^ sxmo_type -k Next
				$icon_prv Previous Tab    ^ 1 ^ sxmo_type -M Alt , -m Alt
				$icon_nxt Next Tab        ^ 1 ^ sxmo_type -M Alt . -m Alt
				$icon_sav Save            ^ 1 ^ sxmo_type -M Ctrl s -m Ctrl
				$icon_cls Quit            ^ 0 ^ sxmo_type -M Ctrl q -m Ctrl
				$icon_fnd Find            ^ 0 ^ sxmo_type -M Ctrl f -m Ctrl
				$icon_fnd Find Previous   ^ 1 ^ sxmo_type -M Ctrl p -m Ctrl
				$icon_fnd Find Next       ^ 1 ^ sxmo_type -M Ctrl n -m Ctrl
				$icon_trm Command Bar     ^ 0 ^ sxmo_type -M Ctrl e -m Ctrl
				$icon_cpy Copy            ^ 0 ^ sxmo_type -M Ctrl c -m Ctrl
				$icon_pst Paste           ^ 0 ^ sxmo_type -M Ctrl v -m Ctrl
				$icon_mnu Terminal menu   ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=Micro
			;;
		*tuir*)
			#tuir (reddit client) in foot
			CHOICES="
				$icon_aru Previous      ^ 1 ^ sxmo_type k
				$icon_ard Next          ^ 1 ^ sxmo_type j
				$icon_aru Scroll up     ^ 1 ^ sxmo_type -k Prior
				$icon_ard Scroll down   ^ 1 ^ sxmo_type -k Next
				$icon_ret Open          ^ 0 ^ sxmo_type o
				$icon_arl Back          ^ 0 ^ sxmo_type h
				$icon_arr Comments      ^ 0 ^ sxmo_type l
				$icon_edt Post          ^ 0 ^ sxmo_type c
				$icon_rld Refresh       ^ 0 ^ sxmo_type r
				$icon_cls Quit          ^ 0 ^ sxmo_type q
				$icon_zmi Zoom in       ^ 1 ^ sxmo_type -k Prior
				$icon_zmo Zoom out      ^ 1 ^ sxmo_type -k Next
				$icon_mnu Terminal menu ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=tuir
			;;
		*w3m*)
			#w3m
			CHOICES="
				$icon_arl Back          ^ 1 ^ sxmo_type b
				$icon_glb Goto URL        ^ 1 ^ sxmo_type u
				$icon_arr Next Link       ^ 1 ^ sxmo_type -k Tab
				$icon_arl Previous Link   ^ 1 ^ sxmo_type -M Shift -k Tab
				$icon_tab Open tab        ^ 0 ^ sxmo_type t
				$icon_cls Close tab       ^ 0 ^ sxmo_type -M Ctrl q
				$icon_itm Next tab        ^ 1 ^ sxmo_type -k braceRight
				$icon_itm Previous tab    ^ 1 ^ sxmo_type -k braceLeft
				$icon_zmi Zoom in          ^ 1 ^ sxmo_type -k Prior
				$icon_zmo Zoom out          ^ 1 ^ sxmo_type -k Next
				$icon_mnu Terminal menu   ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=w3m
			;;
		*ncmpcpp*)
			#ncmpcpp
			CHOICES="
				$icon_lst Playlist        ^ 0 ^ sxmo_type 1
				$icon_fnd Browser         ^ 0 ^ sxmo_type 2
				$icon_fnd Search          ^ 0 ^ sxmo_type 3
				$icon_nxt Next track      ^ 0 ^ sxmo_type -k greater
				$icon_prv Previous track  ^ 0 ^ sxmo_type -k less
				$icon_pau Pause           ^ 0 ^ sxmo_type p
				$icon_stp Stop            ^ 0 ^ sxmo_type s
				$icon_rld Toggle repeat   ^ 0 ^ sxmo_type r
				$icon_sfl Toggle random   ^ 0 ^ sxmo_type z
				$icon_itm Toggle consume  ^ 0 ^ sxmo_type R
				$icon_mnu Terminal menu   ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=ncmpcpp
			;;
		*aerc*)
			#aerc
			CHOICES="
				$icon_pau Archive	  ^ 1 ^ sxmo_type ':archive flat' -k Return
				$icon_nxt Next Tab	  ^ 0 ^ sxmo_type ':next-tab' -k Return
				$icon_prv Previous Tab	  ^ 0 ^ sxmo_type ':prev-tab' -k Return
				$icon_cls Close Tab	  ^ 0 ^ sxmo_type ':close' -k Return
				$icon_itm Next Part	  ^ 1 ^ sxmo_type ':next-part' -k Return
				$icon_trm xdg-open Part	  ^ 0 ^ sxmo_type ':open' -k Return
			"
			WINNAME=aerc
			;;
		*less*|*"git blame"*|*"git diff"*|*"git grep"*|*"git help"*|*"git log"*|*"git stash"*|*"git tag"*|*"git var"*)
			#less
			CHOICES="
				$icon_arr Page next       ^ 1 ^ sxmo_type ':n' -k Return
				$icon_arl Page previous   ^ 1 ^ sxmo_type ':p' -k Return
				$icon_cls Quit            ^ 0 ^ sxmo_type q
				$icon_zmi Zoom in         ^ 1 ^ sxmo_type -M Ctrl +
				$icon_zmo Zoom out        ^ 1 ^ sxmo_type -M Ctrl -k Minus
				$icon_aru Scroll up       ^ 1 ^ sxmo_type -k Prior
				$icon_ard Scroll down     ^ 1 ^ sxmo_type -k Next
				$icon_mnu Terminal menu ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=less
			;;
		*git*)
			# git am, branch, config, tag (and other commands which launch both).
			CHOICES="
				$icon_fil ${PAGER:-less} menu ^ 0 ^ sxmo_appmenu.sh '$WMCLASS ${PAGER:-less}'
				$icon_edt $EDITOR menu ^ 0 ^ sxmo_appmenu.sh '$WMCLASS $EDITOR'
				$icon_mnu Terminal menu ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=git
			;;
		*senpai*)
			CHOICES="
				$icon_aru Scroll up       ^ 1 ^ sxmo_type -k Prior
				$icon_ard Scroll down     ^ 1 ^ sxmo_type -k Next
				$icon_ac1 Previous Buffer ^ 1 ^ sxmo_type -M Alt -k Left
				$icon_ac4 Next Buffer     ^ 1 ^ sxmo_type -M Alt -k Right
				$icon_lst Toggle Channels ^ 0 ^ sxmo_type -k F7
				$icon_usr Toggle Members  ^ 0 ^ sxmo_type -k F8
			"
			WINNAME=senpai
			;;
		*weechat*)
			#weechat
			CHOICES="
				$icon_msg Hotlist Next            ^ 1 ^ sxmo_type -M Alt a
				$icon_arl History Previous        ^ 1 ^ sxmo_type -M Alt -k Less
				$icon_arr History Next            ^ 1 ^ sxmo_type -M Alt -k Greater
				$icon_trm Buffer                  ^ 0 ^ sxmo_type '/buffer '
				$icon_aru Scroll up               ^ 1 ^ sxmo_type -k Prior
				$icon_ard Scroll down             ^ 1 ^ sxmo_type -k Next
				$icon_mnu Terminal menu ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=weechat
			;;
		*" sms "*|*"missed call"*)
			number="$(printf "%s\n" "$WMNAME" | xargs -0 pnc find | tr -d '\n')"
			#sms
			CHOICES="
				$icon_msg Conversation   ^ 0 ^ sxmo_terminal.sh sxmo_modemtext.sh conversationloop $number
				$icon_msg Reply          ^ 0 ^ sxmo_modemtext.sh sendtextmenu $number
				$icon_phn Call           ^ 0 ^ sxmo_modemdial.sh $number
				$([ -d "$SXMO_LOGDIR/$number/attachments" ] && echo "$icon_att View Attachments ^ 1 ^ sxmo_files.sh $SXMO_LOGDIR/$number/attachments --date-sort")
				$(

				found_numbers="$(printf %s "$number" | xargs -I{} pnc find "{}")"
				printf "%s\n" "$found_numbers" | while read -r line; do
					sxmo_contacts.sh --name "$line" | grep -q '???' && echo "$icon_usr Add $line ^ 1 ^ sxmo_contactmenu.sh newcontact $line"
				done
				# if this is a group chain, then allow to add entire chain as a contact too
				if [ "$(printf "%s\n" "$found_numbers" | wc -l)" -gt 1 ]; then
					sxmo_contacts.sh --name "$number" | grep -q '???' && echo "$icon_usr Add $number ^ 1 ^ sxmo_contactmenu.sh newcontact $number"
				fi

				)
				$icon_aru Scroll up       ^ 1 ^ sxmo_type -M Shift -M Ctrl b
				$icon_ard Scroll down     ^ 1 ^ sxmo_type -M Shift -M Ctrl f
				$icon_mnu Terminal menu ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=phone
			;;
		*cmus*)
			# cmus
			# requires `:set set_term_title=false` in cmus to match the application
			CHOICES="
				$icon_itm Play            ^ 0 ^ cmus-remote -p
				$icon_pau Pause           ^ 0 ^ cmus-remote -u
				$icon_stp Stop            ^ 0 ^ cmus-remote -s
				$icon_nxt Next track      ^ 0 ^ cmus-remote -n
				$icon_prv Previous track  ^ 0 ^ cmus-remote -r
				$icon_rld Toggle repeat   ^ 0 ^ cmus-remote -R
				$icon_sfl Toggle random   ^ 0 ^ cmus-remote -S
				$icon_mnu Terminal menu   ^ 0 ^ sxmo_appmenu.sh $WMCLASS
			"
			WINNAME=cmus
			;;
		*iamb*)
			CHOICES="
				$icon_aru Page Up          ^ 1 ^ sxmo_type.sh -k Escape -M Ctrl -k b
				$icon_tab Toggle Selection ^ 0 ^ sxmo_type.sh -k Escape -M Ctrl -k W m
				$icon_ard Page Down        ^ 1 ^ sxmo_type.sh -k Escape -M Ctrl -k f
				$icon_ret Reply To Message ^ 0 ^ sxmo_type.sh -k Escape :reply -k Return
				$icon_tab New Tab          ^ 0 ^ sxmo_type.sh -k Escape :tab rooms -k Return
				$icon_arl Previous Tab     ^ 0 ^ sxmo_type.sh -k Escape :tabp -k Return
				$icon_arr Next Tab         ^ 0 ^ sxmo_type.sh -k Escape :tabn -k Return
				$icon_cls Close Tab        ^ 0 ^ sxmo_type.sh -k Escape :tabclose -k Return
				$icon_win Split View       ^ 0 ^ sxmo_type.sh -k Escape :split -k Return
				$icon_win Split View Vertical ^ 0 ^ sxmo_type.sh -k Escape :vsplit -k Return
				$icon_msg All Chats  ^ 0 ^ sxmo_type.sh -k Escape :chats -k Return
				$icon_msg Direct Messages  ^ 0 ^ sxmo_type.sh -k Escape :dms -k Return
				$icon_grp Rooms            ^ 0 ^ sxmo_type.sh -k Escape :rooms -k Return
				$icon_glb Spaces           ^ 0 ^ sxmo_type.sh -k Escape :spaces -k Return
				$icon_sav Download         ^ 0 ^ sxmo_type.sh -k Escape :download -k Return
				$icon_cls Close View/Quit  ^ 0 ^ sxmo_type.sh -k Escape :quit -k Return
			"
			WINNAME=iamb
			;;
		*)
			# Now we fallback to the default terminal menu
			case "$WMCLASS" in
				*st*)
					STSELMODEON="$(
						printf %s "$XPROPOUT" | grep -E '^_ST_SELMODE.+=' | cut -d= -f2 | tr -d ' '
					)"
					CHOICES="
						$icon_itm Type complete   ^ 0 ^ sxmo_type -M Ctrl -M Shift -k u
						$icon_cpy Copy complete   ^ 0 ^ sxmo_type -M Ctrl -M Shift -k i
						$icon_itm Selmode $(
							[ "$STSELMODEON" = 1 ] &&
							printf %b "$icon_ton" ||
							printf %b "$icon_tof"
							printf %b '^ 0 ^ sxmo_type -M Ctrl -M Shift -k s'
						)
						$([ "$STSELMODEON" = 1 ] && echo 'Copy selection ^ 0 ^ sxmo_type -M Ctrl -M Shift -k c')
						$icon_pst Paste           ^ 0 ^ sxmo_type -M Ctrl -M Shift -k v
						$icon_zmi Zoom in         ^ 1 ^ sxmo_type -M Ctrl -M Shift -k Prior
						$icon_zmo Zoom out        ^ 1 ^ sxmo_type -M Ctrl -M Shift -k Next
						$icon_aru Scroll up       ^ 1 ^ sxmo_type -M Ctrl -M Shift -k b
						$icon_ard Scroll down     ^ 1 ^ sxmo_type -M Ctrl -M Shift -k f
						$icon_a2x Invert          ^ 1 ^ sxmo_type -M Ctrl -M Shift -k x
						$icon_kbd Hotkeys         ^ 0 ^ sxmo_appmenu.sh sthotkeys
					"
					WINNAME=St
					;;
				*foot*)
					CHOICES="
						$icon_cpy Copy		  ^ 0 ^ sxmo_type -M Shift -M Ctrl c
						$icon_pst Paste           ^ 0 ^ sxmo_type -M Shift -M Ctrl v
						$icon_zmi Zoom in         ^ 1 ^ sxmo_type -M Ctrl +
						$icon_zmo Zoom out        ^ 1 ^ sxmo_type -M Ctrl -k Minus
						$icon_aru Scroll up       ^ 1 ^ sxmo_type -M Shift -k Prior
						$icon_ard Scroll down     ^ 1 ^ sxmo_type -M Shift -k Next
						$icon_lnk URL Mode        ^ 0 ^ sxmo_type -M Shift -M Ctrl -k u
						$icon_kbd Hotkeys         ^ 0 ^ sxmo_appmenu.sh sthotkeys
						$icon_fnd Search Field	  ^ 0 ^ sxmo_type -M Ctrl -M Shift -k r
						$icon_aru Search Back	  ^ 0 ^ sxmo_type -M Ctrl -k r
						$icon_ard Search Forward  ^ 0 ^ sxmo_type -M Ctrl -k s
						$icon_itm Search Extend	  ^ 0 ^ sxmo_type -M Ctrl -k w
					"
					WINNAME=Foot
					;;
				*terminal*|org.gnome.vte.application)
					CHOICES="$icon_kbd Hotkeys ^ 0 ^ sxmo_appmenu.sh sthotkeys"
					WINNAME=Terminal
					;;
				*alacritty*)
					CHOICES="
						$icon_cpy Copy				^ 0 ^ sxmo_type -M Shift -M Ctrl c
						$icon_pst Paste				^ 0 ^ sxmo_type -M Shift -M Ctrl v
						$icon_vim VI Mode			^ 0 ^ sxmo_type -M Ctrl -M Shift -k Space
						$icon_fnd Search Forward	^ 0 ^ sxmo_type -M Ctrl -M Shift -k f
						$icon_fnd Search Backward	^ 0 ^ sxmo_type -M Ctrl -M Shift -k b
						$icon_aru Search Previous   ^ 0 ^ sxmo_type -k Enter
						$icon_ard Search Next		^ 0 ^ sxmo_type -M Shift -k Enter
						$icon_kbd Hotkeys 			^ 0 ^ sxmo_appmenu.sh sthotkeys
					"
					WINNAME=Alacritty
					;;
			esac
		esac
		;;
	*okular*)
		# Okular
		CHOICES="
			$icon_cfg Touch $(
				sxmo_wm.sh inputevent touchscreen | grep -q on && \
				printf %b "$icon_ton ^ 0 ^ sxmo_wm.sh inputevent touchscreen off" || \
				printf %b "$icon_tof ^ 0 ^ sxmo_wm.sh inputevent touchscreen on"
			)
		$icon_cfg Fullscreen    ^ 0 ^ sxmo_type -k Ctrl -k Shift -k F
		$icon_cfg Menubar       ^ 0 ^ sxmo_type -k Ctrl -k M
		$icon_cfg Toolbars      ^ 0 ^ sxmo_type -k F7
		$icon_cfg SXMO Bar      ^ 0 ^ sxmo_wm.sh togglebar
		"
		WINNAME=Xournal
		;;
	*xournal*)
		# Xournalpp
		CHOICES="
			$icon_cfg Touch $(
				sxmo_wm.sh inputevent touchscreen | grep -q on && \
				printf %b "$icon_ton ^ 0 ^ sxmo_wm.sh inputevent touchscreen off" || \
				printf %b "$icon_tof ^ 0 ^ sxmo_wm.sh inputevent touchscreen on"
			)
			$icon_flt Open		^ 0 ^ sxmo_type -k Ctrl -k o
			$icon_zmi Zoom		^ 1 ^ sxmo_type -k Ctrl -k plus
			$icon_zmo Zoom		^ 1 ^ sxmo_type -k Ctrl -k minus
			$icon_zmi Next Page	^ 1 ^ sxmo_type -k Next
			$icon_zmo Prev Page	^ 1 ^ sxmo_type -k Prior
			$icon_cfg Menubar       ^ 0 ^ sxmo_type -k F10
			$icon_cfg Toolbars      ^ 0 ^ sxmo_type -k F9
			$icon_cfg SXMO Bar      ^ 0 ^ sxmo_wm.sh togglebar
		"
		WINNAME=Xournal
		;;
	*zathura*)
		# Zathura
		CHOICES="
			$icon_flt Open		^ 0 ^ sxmo_type -k o
			$icon_zmi Zoom		^ 1 ^ sxmo_type -k plus
			$icon_zmo Zoom		^ 1 ^ sxmo_type -k minus
			$icon_arl History	^ 1 ^ sxmo_type -M Ctrl -k o
			$icon_arr History	^ 1 ^ sxmo_type -M Ctrl -k i
			$icon_cfg Invert	^ 0 ^ sxmo_type -M Ctrl -k r
			$icon_flt Index		^ 0 ^ sxmo_type -k Tab
			$icon_cfg Fit           ^ 0 ^ sxmo_type -k a
			$icon_cfg Width mode    ^ 0 ^ sxmo_type -k s
		"
		WINNAME=Zathura
		;;
	*netsurf*)
		# Netsurf
		CHOICES="
			$icon_flt Pipe URL          ^ 0 ^ sxmo_urlhandler.sh
			$icon_lnk Enter URL         ^ 0 ^ sxmo_type.sh -M Ctrl -k l
			$icon_zmi Zoom            ^ 1 ^ sxmo_type -M Ctrl -k plus
			$icon_zmo Zoom            ^ 1 ^ sxmo_type -M Ctrl -k minus
			$icon_arl History        ^ 1 ^ sxmo_type -M Alt -k Left
			$icon_arr History        ^ 1 ^ sxmo_type -M Alt -k Right
		"
		WINNAME=Netsurf
		;;
	*surf*)
		# Surf
		CHOICES="
			$icon_glb Navigate    ^ 0 ^ sxmo_type -M Ctrl g
			$icon_lnk Link Menu   ^ 0 ^ sxmo_type -M Ctrl d
			$icon_flt Pipe URL    ^ 0 ^ sxmo_urlhandler.sh
			$icon_fnd Search Page ^ 0 ^ sxmo_type -M Ctrl f
			$icon_fnd Find Next   ^ 0 ^ sxmo_type -M Ctrl n
			$icon_zmi Zoom      ^ 1 ^ sxmo_type -M Shift -M Ctrl k
			$icon_zmo Zoom      ^ 1 ^ sxmo_type -M Shift -M Ctrl j
			$icon_aru Scroll    ^ 1 ^ sxmo_type -M Shift -k Space
			$icon_ard Scroll    ^ 1 ^ sxmo_type -k Space
			$icon_itm JS Toggle   ^ 1 ^ sxmo_type -M Shift -M Ctrl s
			$icon_arl History   ^ 1 ^ sxmo_type -M Ctrl h
			$icon_arr History   ^ 1 ^ sxmo_type -M Ctrl l
			$icon_rld Refresh     ^ 0 ^ sxmo_type -M Shift -M Ctrl r
		"
		WINNAME=Surf
		;;
	*falkon*)
		# Falkon
		CHOICES="
			$icon_flt Pipe URL          ^ 0 ^ sxmo_urlhandler.sh
			$icon_tab New Tab           ^ 0 ^ sxmo_type -M Ctrl t
			$icon_win New Window        ^ 0 ^ sxmo_type -M Ctrl n
			$icon_cls Close Tab         ^ 0 ^ sxmo_type -M Ctrl w
			$icon_zmi Zoom            ^ 1 ^ sxmo_type -M Ctrl -k plus
			$icon_zmo Zoom            ^ 1 ^ sxmo_type -M Ctrl -k minus
			$icon_arl History        ^ 1 ^ sxmo_type -M Alt -k Left
			$icon_arr History        ^ 1 ^ sxmo_type -M Alt -k Right
			$icon_win Home           ^ 0 ^ sxmo_type -M Alt -k Home
			$icon_zmo Full Screen    ^ 0 ^ sxmo_type -k F11
			$icon_rld Refresh     ^ 0 ^ sxmo_type -M Shift -M Ctrl r
		"
		WINNAME=Falkon
		;;
	*firefox*|*navigator*)
		# Firefox
		CHOICES="
			$icon_flt Pipe URL          ^ 0 ^ sxmo_urlhandler.sh
			$icon_tab New Tab           ^ 0 ^ sxmo_type -M Ctrl t
			$icon_win New Window        ^ 0 ^ sxmo_type -M Ctrl n
			$icon_cls Close Tab         ^ 0 ^ sxmo_type -M Ctrl w
			$icon_zmi Zoom            ^ 1 ^ sxmo_type -M Ctrl -k plus
			$icon_zmo Zoom            ^ 1 ^ sxmo_type -M Ctrl -k minus
			$icon_arl History        ^ 1 ^ sxmo_type -M Alt -k Left
			$icon_arr History        ^ 1 ^ sxmo_type -M Alt -k Right
			$icon_win Home           ^ 0 ^ sxmo_type -M Alt -k Home
			$icon_zmo Full Screen    ^ 0 ^ sxmo_type -k F11
			$icon_rld Refresh     ^ 0 ^ sxmo_type -M Shift -M Ctrl r
		"
		WINNAME=Firefox
		;;
	*krita*)
		# Krita
		CHOICES="
			$icon_fnd Open                   ^ 0 ^ sxmo_type -M Ctrl o
			$icon_sav Save                   ^ 0 ^ sxmo_type -M Ctrl s
			$icon_pst Paste                  ^ 0 ^ sxmo_type -M Ctrl v
			$icon_del Delete                 ^ 0 ^ sxmo_type -k Delete
			$icon_win Select                 ^ 0 ^ sxmo_type -M Ctrl r
			$icon_modem_disabled Deselect    ^ 0 ^ sxmo_type -M Ctrl -M Shift a
			$icon_wn2 Crop                   ^ 0 ^ sxmo_type c
			$icon_flt Fill                   ^ 0 ^ sxmo_type f
			$icon_modem_connected Gradient   ^ 0 ^ sxmo_type g
			$icon_dof HSV Adjust    	     ^ 0 ^ sxmo_type -M Ctrl u
			$icon_cls Close Image        	 ^ 0 ^ sxmo_type -M Ctrl w
		"
		WINNAME=Krita
		;;
	*vimb*)
		CHOICES="
			$icon_glb Navigate        ^ 0 ^ sxmo_type -k Escape o
			$icon_zmi Zoom            ^ 1 ^ sxmo_type -k Escape zi
			$icon_zmo Zoom            ^ 1 ^ sxmo_type -k Escape zo
			$icon_arl History         ^ 1 ^ sxmo_type -M Ctrl o
			$icon_arr History         ^ 1 ^ sxmo_type -M Ctrl i
			$icon_rld Refresh         ^ 0 ^ sxmo_type -k Escape r
		"
		WINNAME=Vimb
		;;
	*geopard*)
		# Geopard
		CHOICES="
			$icon_flt Pipe URL          ^ 0 ^ sxmo_urlhandler.sh
			$icon_pls New Tab            ^ 0 ^ sxmo_type -M Ctrl t
			$icon_cls Close Tab          ^ 0 ^ sxmo_type -M Ctrl w
			$icon_bok Open Bookmarks     ^ 0 ^ sxmo_type -M Ctrl b
			$icon_pls Add Bookmark       ^ 0 ^ sxmo_type -M Ctrl d
			$icon_edt Edit Bookmarks     ^ 0 ^ sxmo_terminal.sh $EDITOR ~/.local/share/geopard/bookmarks.gemini
			$icon_zmi Increase Font Size ^ 1 ^ sxmo_type -M Ctrl -k plus
			$icon_zmo Decrease Font Size ^ 1 ^ sxmo_type -M Ctrl -k minus
			$icon_arl History Back       ^ 1 ^ sxmo_type -M Alt -k Left
			$icon_arr History Forward    ^ 1 ^ sxmo_type -M Alt -k Right
			$icon_fnd URL Bar            ^ 0 ^ sxmo_type -k F6
			$icon_rld Refresh            ^ 0 ^ sxmo_type -k F6 -k Return
			"
		WINNAME=Geopard
		;;
	*lagrange*)
		# Lagrange
		CHOICES="
			$icon_mnu Toggle sidebar ^ 0 ^ sxmo_type -M Shift -M Ctrl p
			$icon_bok Open bookmarks ^ 0 ^ sxmo_type -M Ctrl l && sxmo_type 'about:bookmarks' -k Return
			$icon_pls Add bookmark   ^ 0 ^ sxmo_type -M Ctrl d
			$icon_zmi Zoom           ^ 1 ^ sxmo_type -M Ctrl -k equal
			$icon_zmo Zoom           ^ 1 ^ sxmo_type -M Ctrl -k minus
			$icon_aru Parent dir     ^ 1 ^ sxmo_type -M Alt -k Up
			$icon_arl History        ^ 1 ^ sxmo_type -M Alt -k Left
			$icon_arr History        ^ 1 ^ sxmo_type -M Alt -k Right
			$icon_rld Refresh        ^ 0 ^ sxmo_type -M Ctrl r
		"
		WINNAME=Lagrange
		;;
	org.gnome.maps)
	CHOICES="
		$icon_gps Toggle Geoclue ^ 0 ^ superctl status geoclue-agent |grep started >/dev/null && superctl stop geoclue-agent || superctl start geoclue-agent
		$icon_zmi Zoom in ^ 1 ^ sxmo_type -M ctrl =
		$icon_zmo Zoom out ^ 1 ^ sxmo_type -M ctrl -k minus
		$icon_fnd Explore POI ^ 0 ^ sxmo_type -M ctrl -M Shift F
		$icon_fnd Search ^ 0 ^ sxmo_type -M ctrl f
		$icon_lst Show last results ^ 0 ^ sxmo_type -M ctrl r
		$icon_map Toggle route planner ^ 0 ^ sxmo_type -M ctrl d
		$icon_gps Show current location ^ 0 ^ sxmo_type -M ctrl l
		"
		WINNAME=Maps
		;;
	*mepo*)
		# Mepo
		# The choices / hotkeys for the contextmenu are generated through mepo's
		# own scripting to be in congruence since the same menu can be launched
		# via mepo's UI as well, this compatibility is available as of mepo 0.4
		CHOICES="$(mepo_ui_central_menu.sh menuoptions | awk -F^ '{ print $1 "^ 0 ^ sxmo_type" $3  }')"
		WINNAME=Mepo
		;;
	*foxtrot*)
		# Foxtrot GPS
		CHOICES="
			$icon_zmi Zoom              ^ 1 ^ sxmo_type i
			$icon_zmo Zoom              ^ 1 ^ sxmo_type o
			$icon_itm Panel Toggle        ^ 1 ^ sxmo_type m
			$icon_itm GPSD Toggle         ^ 1 ^ sxmo_type a
		"
		WINNAME=Maps
		;;
	*badwolf*)
		# Badwolf Browser
		CHOICES="
			$icon_tab New Tab           ^ 0 ^ sxmo_type -M Ctrl -k t
			$icon_cls Close Tab         ^ 0 ^ sxmo_type -M Alt -k d
			$icon_fnd Reset Zoom     ^ 0 ^ sxmo_type -M Ctrl -k 0
			$icon_arr History        ^ 1 ^ sxmo_type -M Ctrl ]
			$icon_arl History        ^ 1 ^ sxmo_type -M Ctrl [
			$icon_arr Next Tab          ^ 1 ^ sxmo_type -M Alt -k Right
			$icon_arl Previous Tab      ^ 1 ^ sxmo_type -M Alt -k Left
			$icon_rld Refresh     ^ 0 ^ sxmo_type -M Shift -M Ctrl -k r
			$icon_fnd Search     ^ 0 ^ sxmo_type -M Shift -M Ctrl -k f
			$icon_arr Next (Search)     ^ 0 ^ sxmo_type -M Shift -M Ctrl -k g
			$icon_arl Previous (Search)     ^ 0 ^ sxmo_type -M Shift -M Ctrl -M Shift -k g
			$icon_flt URL Bar     ^ 0 ^ sxmo_type -M Shift -M Ctrl l
			$icon_fnd Open Web Inspector      ^ 0 ^ sxmo_type -k F12
		"
		WINNAME=Badwolf
		;;
	*acme*)
		# Acme
		CHOICES="
			$icon_mse 2 (Right) [2s delay]  ^ 0 ^ sleep 2 && xdotool click 3
			$icon_mse 3 (Middle) [2s delay]  ^ 0 ^ sleep 2 && xdotool click 2
			$icon_itm Autocomplete            ^ 0 ^ sxmo_type.sh -M Ctrl -k f
			$icon_exp Select Last Typed Text  ^ 0 ^ sxmo_type.sh -M Escape
			$icon_del Delete To Start Of Line       ^ 0 ^ sxmo_type.sh -M Ctrl -k U
			$icon_arl Move To Start Of Line   ^ 0 ^ sxmo_type.sh -M Ctrl -k A
			$icon_arr Move To End Of Line      ^ 0 ^ sxmo_type.sh -M Ctrl -k E
		"
		WINNAME=Acme
		;;
	*mupdf*)
		# Mupdf
		CHOICES="
			$icon_nxt Next Page           ^ 0 ^ sxmo_type -k Space
			$icon_prv Previous Page         ^ 0 ^ sxmo_type -k b
			$icon_chk Mark Page		^ 0 ^ sxmo_type -k m
			$icon_ret Pop To Last Mark        ^ 0 ^ sxmo_type -k t
			$icon_zmi Zoom In        ^ 1 ^ sxmo_type -k +
			$icon_zmo Zoom Out          ^ 1 ^ sxmo_type -k -
			$icon_fnd Fit Width      ^ 0 ^ sxmo_type -k W
			$icon_fnd Fit Height     ^ 0 ^ sxmo_type -k H
			$icon_fnd Zoom To Fit     ^ 0 ^ sxmo_type -k Z
			$icon_fnd Reset Zoom     ^ 0 ^ sxmo_type -k z
			$icon_rol Rotate Counterclockwise     ^ 0 ^ sxmo_type -k [
			$icon_ror Rotate Clockwise     ^ 0 ^ sxmo_type -k ]
			$icon_fnd Search     ^ 0 ^ sxmo_type -k /
		"
		WINNAME=Mupdf
		;;
	*tabbed*)
		# Tabbed
		CHOICES="
			$icon_tab New Tab            ^ 0 ^ sxmo_type.sh -M Ctrl -M Shift -M Enter
			$icon_arl Previous Tab       ^ 1 ^ sxmo_type.sh -M Ctrl -M Shift -k h
			$icon_arr Next Tab           ^ 1 ^ sxmo_type.sh -M Ctrl -M Shift -k l
			$icon_arl Move Tab Left      ^ 1 ^ sxmo_type.sh -M Ctrl -M Shift -k j
			$icon_arr Move Tab Right     ^ 1 ^ sxmo_type.sh -M Ctrl -M Shift -k k
			$icon_mnu Menu Prompt        ^ 0 ^ sxmo_type.sh -M Ctrl -k U0060
			$icon_cls Close Tab          ^ 0 ^ sxmo_type.sh -M Ctrl -k q
		"
		WINNAME=Tabbed
		;;
	*links*)
		# Links Browser
		CHOICES="
			$icon_mnu Menu                 ^ 0 ^ sxmo_type.sh -k Escape
			$icon_ret Follow Link          ^ 0 ^ sxmo_type.sh -k Enter
			$icon_arl History              ^ 1 ^ sxmo_type.sh -k z
			$icon_arr History              ^ 1 ^ sxmo_type.sh -k x
			$icon_glb Enter URL            ^ 0 ^ sxmo_type.sh -k g
			$icon_glb Edit Current URL     ^ 0 ^ sxmo_type.sh -k G
			$icon_glb View Highlighted URL ^ 0 ^ sxmo_type.sh -M Ctrl -k g
			$icon_cam Toggle Images        ^ 0 ^ sxmo_type.sh -k U002A
			$icon_aru Scroll Up            ^ 1 ^ sxmo_type.sh -k p
			$icon_ard Scroll Down          ^ 1 ^ sxmo_type.sh -k l
			$icon_arl Scroll Left          ^ 1 ^ sxmo_type.sh -k U005B
			$icon_arr Scroll Right         ^ 1 ^ sxmo_type.sh -k U005D
		"
		WINNAME=Links
		;;
	*)
		# Default system menu (no matches)
		CHOICES="
			$icon_grd Scripts                                            ^ 0 ^ sxmo_appmenu.sh scripts
			$icon_grd Apps                                               ^ 0 ^ sxmo_appmenu.sh applications
			$([ "$SXMO_MENU" = "wofi" ] && echo "$icon_grd All Apps      ^ 0 ^ wofi -O alphabetical -i --show drun")
			$([ "$SXMO_MENU" != "wofi" ] && command -v j4-dmenu-desktop > /dev/null && echo "$icon_grd All Apps     ^ 0 ^ j4-dmenu-desktop --dmenu=sxmo_dmenu.sh --term=sxmo_terminal.sh")
			$icon_grd Binaries                                           ^ 0 ^ sxmo_brun.sh
			$icon_dir Files                                              ^ 0 ^ sxmo_files.sh
			$icon_phn Dialer                                             ^ 0 ^ sxmo_modemdial.sh
			$icon_msg Texts                                              ^ 0 ^ sxmo_modemtext.sh
			$icon_usr Contacts                                           ^ 0 ^ sxmo_contactmenu.sh
			$(
				rfkill list bluetooth -no ID,SOFT,HARD | grep -vq " blocked" &&
				printf %b "$icon_bth Bluetooth ^ 1 ^ sxmo_bluetoothmenu.sh"
			)
			$(command -v megapixels >/dev/null && echo "$icon_cam Camera ^ 0 ^ GDK_SCALE=2 megapixels")
			$(
				if brightness="$(brightnessctl -d "white:flash" get)"; then
					printf "%s Flashlight " "$icon_fll"
					[ "$brightness" -gt 0 ] &&
						printf %b "$icon_ton" ||  printf %b "$icon_tof";
					printf %b "^ 1 ^ sxmo_flashtoggle.sh"
				fi
			)
			$icon_net Networks                                           ^ 0 ^ sxmo_networks.sh
			$icon_mus Audio                                              ^ 0 ^ sxmo_audio.sh
			$icon_phn Modem                                              ^ 0 ^ sxmo_appmenu.sh modem
			$icon_win Windows                                            ^ 0 ^ sxmo_wmmenu.sh
			$icon_cfg Config                                             ^ 0 ^ sxmo_appmenu.sh config
			$icon_inf Help                                               ^ 0 ^ sxmo_terminal.sh man sxmo
			$icon_pwr Power                                              ^ 0 ^ sxmo_appmenu.sh power
		"
		WINNAME=Sys
		;;
esac

printf "%b\n" "$WINNAME"
printf "%b\n" "$CHOICES"
