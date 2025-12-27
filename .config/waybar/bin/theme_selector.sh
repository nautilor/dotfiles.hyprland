#!/usr/bin/env bash

BASEDIR="$HOME/.config/waybar/"
VERTICAL_BASEDIR="$HOME/.config/waybar/themes/vertical/"
HORIZONTAL_BASEDIR="$HOME/.config/waybar/themes/horizontal/"

THEME=`printf "Horizontal\nVertical" | rofi -dmenu -theme menu`
if [ "$THEME" == "Horizontal" ]; then
	cp -R "$HORIZONTAL_BASEDIR"* "$BASEDIR"
elif [ "$THEME" == "Vertical" ]; then
	cp -R "$VERTICAL_BASEDIR"* "$BASEDIR"
else
	exit 0
fi

killall waybar
notify-send -i "info" "Waybar Theme Changed" "Applied $THEME theme to Waybar."
waybar & disown
