#!/bin/sh

rv=$(echo -e "PC screen only|Extend|Second screen only" | rofi -dmenu -sep '|' -lines 3 -width 100 -padding 860 -mesg "Display" -u 3-4 -selected-row 1 -i -p "")
echo $rv

case $rv in
   "PC screen only")
      (xrandr --output eDP1 --mode 1920x1080 --output HDMI1 --off) &
      ;;
   "Extend")
      (xrandr --output eDP1 --mode 1920x1080 --output HDMI1 --mode 2560x1440 --left-of eDP1) &
      ;;
   "Second screen only")
      (xrandr --output eDP1 --off --output HDMI1 --mode 2560x1440 --left-of eDP1) &
      ;;
esac

