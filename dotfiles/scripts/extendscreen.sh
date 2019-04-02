#!/bin/sh
set -x

POLYBAR_RELAUNCH="$HOME/.config/polybar/launch.sh"
WALLPAPER="$HOME/.wallpaper"

if [ "$HOSTNAME" = "regretful-arch" ]; then
	rv=$(printf "PC screen only|Extend|Second screen only" | rofi -dmenu -sep '|' -lines 3 -width 100 -padding 860 -mesg "Display" -u 3-4 -selected-row 1 -i -p "")
	echo $rv

	case $rv in
		"PC screen only")
			xrandr --output eDP1 --auto --output HDMI1 --off
			;;
		"Extend")
			xrandr --output eDP1 --auto --output HDMI1 --auto --right-of eDP1
			;;
		"Second screen only")
			xrandr --output eDP1 --off --output HDMI1 --auto
			;;
	esac

elif [ $(hostname) = "ingvaeonic" ]; then
	rv=$(printf "Main only|Both" | rofi -dmenu -sep '|' -lines 3 -width 100 -padding 860 -mesg "Display" -u 3-4 -selected-row 1 -i -p "")
	echo $rv

	case $rv in
		"Main only")
			xrandr --output DP-0 --auto --output HDMI-0 --off
			;;
		"Both")
			xrandr --output DP-0 --auto --output HDMI-0 --auto --right-of DP-0
			;;
	esac

else
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
