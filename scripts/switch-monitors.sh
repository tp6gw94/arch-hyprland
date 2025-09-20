#!/bin/bash

# Switch between home and work monitor configurations
HYPR_DIR="$HOME/.config/hypr"
CURRENT_CONFIG="$HYPR_DIR/monitors-current.conf"

# Check if a specific config is requested
if [ "$1" == "home" ]; then
    ln -sf "$HYPR_DIR/monitors-home.conf" "$CURRENT_CONFIG"
    echo "🏠 Switched to HOME monitor configuration"
elif [ "$1" == "work" ]; then
    ln -sf "$HYPR_DIR/monitors-work.conf" "$CURRENT_CONFIG"
    echo "💼 Switched to WORK monitor configuration"
elif [ "$1" == "toggle" ] || [ -z "$1" ]; then
    # Toggle between configurations
    if [ -L "$CURRENT_CONFIG" ]; then
        CURRENT=$(readlink "$CURRENT_CONFIG")
        if [[ "$CURRENT" == *"monitors-home.conf" ]]; then
            ln -sf "$HYPR_DIR/monitors-work.conf" "$CURRENT_CONFIG"
            echo "💼 Switched to WORK monitor configuration"
        else
            ln -sf "$HYPR_DIR/monitors-home.conf" "$CURRENT_CONFIG"
            echo "🏠 Switched to HOME monitor configuration"
        fi
    else
        # Default to home if no symlink exists
        ln -sf "$HYPR_DIR/monitors-home.conf" "$CURRENT_CONFIG"
        echo "🏠 Initialized with HOME monitor configuration"
    fi
elif [ "$1" == "status" ]; then
    if [ -L "$CURRENT_CONFIG" ]; then
        CURRENT=$(readlink "$CURRENT_CONFIG")
        if [[ "$CURRENT" == *"monitors-home.conf" ]]; then
            echo "Current: 🏠 HOME"
        else
            echo "Current: 💼 WORK"
        fi
    else
        echo "No configuration set"
    fi
else
    echo "Usage: $0 [home|work|toggle|status]"
    echo "  home   - Switch to home monitor setup"
    echo "  work   - Switch to work monitor setup"
    echo "  toggle - Toggle between home and work"
    echo "  status - Show current configuration"
    exit 1
fi

# Only reload if we actually switched (not for status)
if [ "$1" != "status" ]; then
    hyprctl reload
fi