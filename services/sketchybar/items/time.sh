#!/usr/bin/env bash

sketchybar --add item calendar.time right \
          --set calendar.time update_freq=10 icon.drawing=off script="$PLUGIN_DIR/time.sh"
