#!/bin/bash

# Get current song info using playerctl
player_status=$(playerctl -p spotify status 2>/dev/null)
if [ "$player_status" != "Playing" ] && [ "$player_status" != "Paused" ]; then
  echo '{"text": "  No music playing", "tooltip": "Spotify not active"}'
  exit
fi

artist=$(playerctl -p spotify metadata artist)
title=$(playerctl -p spotify metadata title)

# Get position and duration
position=$(playerctl -p spotify position 2>/dev/null)
duration=$(playerctl -p spotify metadata mpris:length 2>/dev/null)
if [ -z "$duration" ] || [ "$duration" -eq 0 ]; then
  echo "{\"text\": \"  $artist - $title\", \"tooltip\": \"$artist - $title\"}"
  exit
fi

# Convert microseconds to seconds
duration_sec=$((duration / 1000000))
position_sec=${position%.*}

# Compute progress bar
progress_length=10
filled=$((position_sec * progress_length / duration_sec))
empty=$((progress_length - filled))

progress=$(printf '%0.s█' $(seq 1 $filled))
progress+=$(printf '%0.s░' $(seq 1 $empty))

echo "{\"text\": \"  $artist - $title [$progress]\", \"tooltip\": \"$artist - $title\"}"
