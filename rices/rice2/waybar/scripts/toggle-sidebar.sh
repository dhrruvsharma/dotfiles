#!/usr/bin/env bash

SIDEBAR_CMD="waybar -c /home/igris/.config/waybar/sidebar-config -s /home/igris/.config/waybar/sidebar-style.css"

if pgrep -f "$SIDEBAR_CMD" >/dev/null; then
  pkill -f "$SIDEBAR_CMD"
else
  $SIDEBAR_CMD &
fi
