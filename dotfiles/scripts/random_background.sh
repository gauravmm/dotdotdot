#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Wallpapers"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    mkdir "$WALLPAPER_DIR"
fi

if [[ -f "$HOME/.fehbg" ]]; then
    rm "$HOME/.fehbg"
fi

WALLPAPER=$(ls "$WALLPAPER_DIR" | sort -R | head -n1 | tr -s "\n")

if [[ ! -e $WALLPAPER ]]; then
    echo "Setting wallpaper to $WALLPAPER_DIR/$WALLPAPER"

    WALLPAPER_PATH="$WALLPAPER_DIR/$WALLPAPER"
    feh --no-fehbg --bg-fill "$WALLPAPER_PATH"
    echo "$WALLPAPER_PATH" > "$HOME/.wallpaper"
else
    echo "No wallpaper found."
fi
