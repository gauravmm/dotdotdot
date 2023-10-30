#!/bin/sh
set -x

POLYBAR_RELAUNCH="$HOME/.config/polybar/launch.sh"
WALLPAPER="$HOME/.wallpaper"

if [ $(hostname) = "alessi" ]; then
	rv=$(printf "PC screen only|Extend|Second screen only" | rofi -dmenu -sep '|' -lines 3 -width 100 -padding 860 -mesg "Display" -u 3-4 -selected-row 1 -i -p "")
	echo $rv

	case $rv in
		"PC screen only")
			xrandr --output eDP-1 --auto --output HDMI-1 --off
			;;
		"Extend")
			xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1
			;;
		"Second screen only")
			xrandr --output eDP-1 --off --output HDMI-1 --auto
			;;
	esac

else
	notify-send "No extend-screen script for $(hostname)."
	exit;
fi


if [ -x "$POLYBAR_RELAUNCH" ]; then
	("$POLYBAR_RELAUNCH" &)
fi

if [ -f $WALLPAPER ]; then
	WALL=$(head -n1 $WALLPAPER | tr -s "\n")
	if [ ! -z $WALL ]; then
		feh --no-fehbg --bg-fill "$WALL"
	fi
fi
