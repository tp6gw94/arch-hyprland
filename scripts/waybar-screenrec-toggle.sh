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

    # Get monitor list
    monitors=$(hyprctl monitors -j | jq -r '.[] | "\(.name) (\(.width)x\(.height))"')

    # Add region selection option
    options="Select Region
$monitors"

    # Let user choose recording mode
    choice=$(echo "$options" | tofi --prompt-text=" Recording Mode: ")

    if [ -z "$choice" ]; then
        exit 0
    fi

    filename="$SCREEN_RECORDING_DIR/$(date +%Y-%m-%d_%H-%M-%S).mp4"

    if [ "$choice" = "Select Region" ]; then
        # Get selection area
        area=$(slurp 2>/dev/null)
        if [ -n "$area" ]; then
            wl-screenrec --low-power=off -g "$area" -f "$filename" &
            notify-send "Screen Recording" "Recording region started" -i camera-video
        fi
    else
        # Extract monitor name from choice
        monitor_name=$(echo "$choice" | cut -d' ' -f1)
        wl-screenrec --low-power=off -o "$monitor_name" -f "$filename" &
        notify-send "Screen Recording" "Recording $monitor_name started" -i camera-video
    fi
fi