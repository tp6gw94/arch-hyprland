#!/bin/bash

# Check if wl-screenrec is running
if pgrep -x "wl-screenrec" > /dev/null; then
    # Stop recording
    pkill -INT wl-screenrec
    notify-send "Screen Recording" "Recording stopped" -i camera-video
else
    # Start recording
    SCREEN_RECORDING_DIR="${SCREEN_RECORDING_DIR:-$HOME/ScreenRecordings}"
    mkdir -p "$SCREEN_RECORDING_DIR"

    # Get selection area
    area=$(slurp 2>/dev/null)

    if [ -n "$area" ]; then
        filename="$SCREEN_RECORDING_DIR/$(date +%Y-%m-%d_%H-%M-%S).mp4"
        wl-screenrec --low-power=off -g "$area" -f "$filename" &
        notify-send "Screen Recording" "Recording started" -i camera-video
    fi
fi