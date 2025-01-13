#!/bin/bash

ICON=""

if [[ $SENDER == "window_changed" ]]; then
   # Get all windows in current space
   SPACE_WINDOWS=$(yabai -m query --windows --space)
   
   if [[ -n "$SPACE_WINDOWS" ]]; then
     # Check if any window has fullscreen zoom
     HAS_FULLSCREEN=$(
       echo "$SPACE_WINDOWS" | \
       jq 'map(."has-fullscreen-zoom") | any')
     if [[ "$HAS_FULLSCREEN" == "true" ]]; then
       ICON="●"
     fi
   fi
fi

sketchybar --set fullscreen icon="$ICON"
