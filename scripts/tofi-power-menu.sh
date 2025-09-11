#!/bin/bash

options="🔒 Lock\n🚪 Logout\n🔄 Reboot\n⚡ Shutdown\n💤 Sleep\n🔄 Restart Hyprland"

chosen=$(echo -e "$options" | tofi --prompt-text "Power Menu: ")

case "$chosen" in
    "🔒 Lock")
        # 使用 hyprlock
        hyprlock
        ;;
    "🚪 Logout")
        # 登出 Hyprland
        hyprctl dispatch exit
        ;;
    "🔄 Reboot")
        systemctl reboot
        ;;
    "⚡ Shutdown")
        systemctl poweroff
        ;;
    "💤 Sleep")
        systemctl suspend
        ;;
    "🔄 Restart Hyprland")
        hyprctl dispatch exec "hyprctl reload"
        ;;
    *)
        # 取消或無效選擇
        exit 1
        ;;
esac
