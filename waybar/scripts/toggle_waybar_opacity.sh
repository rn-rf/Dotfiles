#!/bin/bash

CONFIG_DIR="$HOME/.config/waybar"
THEME_DIR="$CONFIG_DIR/style"
ACTIVE_STYLE="$CONFIG_DIR/style.css"

if "$CONFIG_DIR/scripts/one_window.sh" | grep -q true; then
    cp "$THEME_DIR/opaque.css" "$ACTIVE_STYLE"
else
    cp "$THEME_DIR/transparent.css" "$ACTIVE_STYLE"
fi

