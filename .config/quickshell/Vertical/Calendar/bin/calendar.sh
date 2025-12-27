#!/usr/bin/env bash

PID=$(quickshell list --all | awk '
  /Instance /   { pid="" }
  /Process ID:/ { pid=$3 }
  /Config path:.*\/Calendar\/shell\.qml$/ { print pid; exit }
	')



if [ -z "$PID" ]; then
	quickshell --config ~/.config/quickshell/Calendar &
else
	kill "$PID"
fi
