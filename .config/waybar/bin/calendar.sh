#!/usr/bin/env bash

if [ "$1" == "--vertical" ]; then
	CONFIGURATION="Vertical"
elif [ "$1" == "--horizontal" ]; then
	CONFIGURATION="Horizontal"
else
	CONFIGURATION="Horizontal"
fi

echo "Using configuration: $CONFIGURATION"

PID=$(quickshell list --all | awk '
  /Instance /   { pid="" }
  /Process ID:/ { pid=$3 }
  /Config path:.*\/Calendar\/shell\.qml$/ { print pid; exit }
	')

if [ -z "$PID" ]; then
	quickshell --config ~/.config/quickshell/$CONFIGURATION/Calendar &
else
	kill "$PID"
fi
