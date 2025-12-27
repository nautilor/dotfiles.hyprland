#!/usr/bin/env bash

if ! command -v clipse &> /dev/null || ! command -v clipse-gui &> /dev/null || ! command -v wl-copy &> /dev/null; then
		notify-send -i "error" "Clipboard Manager" "Required dependencies are not installed!"
		echo "Please install 'cliphist', 'rofi', and 'wl-copy' to use this script."
		exit 1
fi

# when pressing escape from the clipse-gui, it leaves a zombie process
if pgrep -x "clipse-gui" > /dev/null; then
	pkill -x "clipse-gui"
	exit 0
fi


select_clipboard() {
	clipse-gui
}

clear_clipboard() {
	clipse -clear-all
	notify-send -i "clipboard" "Clipboard Cleared" "All clipboard history has been cleared."
}


if [ "$@" == "clear" ]; then
	clear_clipboard
else
	select_clipboard
fi
