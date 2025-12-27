#!/usr/bin/env bash

OUTPUT_IMAGE="/tmp/colorpicker.png"
COLOR=`hyprpicker`

[ -z "$COLOR" ] && exit 1

echo -n $COLOR | wl-copy

magick -size 100x100 xc:none -fill "${COLOR}" -draw "roundRectangle 0,0 100,100 15,15" "$OUTPUT_IMAGE"

notify-send -i "$OUTPUT_IMAGE" "Color Copied" "${COLOR}"

rm "$OUTPUT_IMAGE"
