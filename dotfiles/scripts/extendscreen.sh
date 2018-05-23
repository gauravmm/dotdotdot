#!/bin/sh

rv=$(echo -e "PC screen only|Extend|Second screen only" | rofi -dmenu -sep '|' -lines 3 -width 100 -padding 860 -mesg "Display" -u 3-4 -selected-row 1 -i -p "")
echo $rv

case $rv in
   "PC screen only")
      (xrandr --output eDP-1 --auto --output HDMI-1 --off) &
      ;;
   "Extend")
      (xrandr --output eDP-1 --auto --output HDMI-1 --auto --left-of eDP-1) &
      ;;
   "Second screen only")
      (xrandr --output eDP-1 --off --output HDMI-1 --auto --left-of eDP-1) &
      ;;
esac

