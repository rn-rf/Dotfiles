#!/bin/bash

# Get active workspace name
workspace=$(hyprctl activeworkspace -j | jq -r '.name')

# Count windows on that workspace
window_count=$(hyprctl clients -j | jq --arg ws "$workspace" '[.[] | select(.workspace.name == $ws)] | length')

# Check if only one window exists
if [ "$window_count" -eq 1 ]; then
    echo true
else
    echo false
fi

