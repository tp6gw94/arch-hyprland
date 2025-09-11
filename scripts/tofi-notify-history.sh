#!/bin/bash

# 檢查 dunstctl 是否可用
if ! command -v dunstctl &> /dev/null; then
    notify-send "Error" "dunstctl not found"
    exit 1
fi

history_data=$(dunstctl history)
if [ -z "$history_data" ] || [ "$history_data" = "null" ]; then
    notify-send "Notify History" "No History"
    exit 0
fi

notifications=$(echo "$history_data" | jq -r '
    if .data and .data[0] then 
        .data[0][] | 
        (.timestamp.data | tonumber | strftime("%H:%M")) + " | " + 
        .appname.data + " | " + 
        .summary.data + 
        (if .body.data != "" then " - " + .body.data else "" end)
    else 
        empty 
    end' 2>/dev/null)

if [ -z "$notifications" ]; then
    notify-send "Notify History" "Cant parse notify history."
    exit 1
fi

selected=$(echo "$notifications" | tofi --prompt-text "Notify History: ")

if [ -n "$selected" ]; then
    echo "$selected" | wl-copy  
    notify-send "Notify History" "Copy to lcipboard"
fi
