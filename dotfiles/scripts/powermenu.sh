#!/bin/sh

rv=$(printf "Cancel|Lock|Sleep|Log Off|Shutdown|Reboot" | rofi -dmenu -sep '|' -lines 5 -width 100 -padding 900 -mesg "Power" -u 3-4 -selected-row 2 -i -p "")
echo $rv

case $rv in
   "Lock")
      ~/.scripts/lockscreen.sh
      ;;
   "Sleep")
      ~/.scripts/lockscreen.sh && sudo systemctl suspend
      ;;
   "Log Off")
      exec i3-msg exit
      ;;
   "Shutdown")
      sudo systemctl poweroff
      ;;
    "Reboot")
      sudo systemctl reboot
      ;;
esac
