#!/usr/bin/env bash

WALLPAPER_ID="$HOME/.wallpaper"

WALLPAPER_PATH=$(head -n1 $WALLPAPER_ID)
echo "Locking with $WALLPAPER_PATH as background"

if ! [[ $WALLPAPER_PATH = *.png ]]; then
    TEMP_PATH=$(mktemp --suffix .png)
    convert $WALLPAPER_PATH $TEMP_PATH
    NEW_WALLPAPER_PATH="${WALLPAPER_PATH%.*}.png"
    mv $TEMP_PATH $NEW_WALLPAPER_PATH
    echo $NEW_WALLPAPER_PATH > $WALLPAPER_ID
    rm "$WALLPAPER_PATH"
    WALLPAPER_PATH=$NEW_WALLPAPER_PATH
fi

i3lock -i $WALLPAPER_PATH --color \#000000
