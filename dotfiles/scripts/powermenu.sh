#!/bin/sh

rv=$(printf "Cancel|Lock|Sleep|Log Off|Shutdown|Reboot" | rofi -dmenu -sep '|' -lines 5 -width 100 -padding 900 -mesg "Power" -u 3-4 -selected-row 2 -i -p "")
echo $rv

case $rv in
   "Lock")
      ~/.scripts/lockscreen.sh
      ;;
   "Blank")
       ~/.scripts/lockscreen.sh
      sleep 1; xset dpms force off
      ;;
   "Sleep")
      ~/.scripts/lockscreen.sh && sudo pm-suspend
      ;;
   "Log Off")
      exec i3-msg exit
      ;;
   "Shutdown")
      poweroff
      ;;
    "Reboot")
      reboot
      ;;
esac
