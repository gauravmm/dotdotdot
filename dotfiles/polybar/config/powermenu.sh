#!/bin/sh

rv=$(echo -e "Cancel|Lock|Log Off|Shutdown|Reboot" | rofi -dmenu -sep '|' -lines 5 -width 100 -padding 900 -mesg "Power" -u 3-4 -selected-row 1 -i -p "")
echo $rv

case $rv in
   "Lock")
      (sleep .5; i3lock-wrapper) &
      ;;
   "Log Off")
      exec i3-msg exit &
      ;;
   "Shutdown")
      sudo poweroff &
      ;;
    "Reboot")
      sudo reboot &
      ;;
esac

