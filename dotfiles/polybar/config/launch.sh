#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

HOST=$(hostname)
while IFS="" read -r item || [ -n "$item" ]; do
    export POLYBAR_DISPLAY=${item%%:*}
    export POLYBAR_DPI=96
    if [ "$HOST" = "regretful-arch" ] && [ "$item" = "eDP1: 1920x1080+0+0" ]; then
        export POLYBAR_DPI=96
    elif [ "$HOST" = "regretful-arch" ] && [ "${item:0:16}" = "HDMI1: 3840x2160" ]; then
        export POLYBAR_DPI=120
    elif [ "$HOST" = "ingvaeonic" ] && [ "$item" = "DP-2: 3840x2160+0+0" ]; then
        export POLYBAR_DPI=120
    fi

    echo "Setting $HOST::$item to $POLYBAR_DPI"

    polybar top &
    polybar bottom &
done <<< $(polybar -m)
