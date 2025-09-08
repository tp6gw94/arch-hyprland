#!/bin/bash

case "$1" in
    region|r)
        hyprshot -m region --raw | satty --filename - \
            --copy-command=wl-copy \
            --actions-on-enter="save-to-clipboard" \
            --actions-on-escape="exit" \
            --output-filename ~/screenshots/$(date '+%Y%m%d-%H:%M:%S').png \
						--early-exit
        ;;
    window|w)
        hyprshot -m window --raw | satty --filename - \
            --copy-command=wl-copy \
            --actions-on-enter="save-to-clipboard" \
            --actions-on-escape="exit" \
            --output-filename ~/screenshots/$(date '+%Y%m%d-%H:%M:%S').png \
						--early-exit
        ;;
    output|o)
        hyprshot -m output --raw | satty --filename - \
            --copy-command=wl-copy \
            --actions-on-enter="save-to-clipboard" \
            --actions-on-escape="exit" \
            --output-filename ~/screenshots/$(date '+%Y%m%d-%H:%M:%S').png \
						--early-exit
        ;;
    *)
        echo "Usage: $0 {region|window|output}"
        echo "  region|r  - 選擇區域截圖"
        echo "  window|w  - 視窗截圖"  
        echo "  output|o  - 全螢幕截圖"
        exit 1
        ;;
esac
