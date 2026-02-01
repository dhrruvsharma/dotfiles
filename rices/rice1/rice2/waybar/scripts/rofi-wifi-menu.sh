#!/bin/bash

# Get list of SSIDs
ssid_list=$(nmcli -t -f SSID device wifi list | grep -v '^$' | sort -u)

# Show menu with Rofi
chosen_ssid=$(echo "$ssid_list" | rofi -dmenu -theme ~/.config/rofi/wifi.rasi -p "Wi-Fi SSID")

# Exit if nothing selected
[ -z "$chosen_ssid" ] && exit

# Check if the network is already known
if nmcli connection show | grep -q "$chosen_ssid"; then
  nmcli connection up "$chosen_ssid"
else
  # Prompt for password
  password=$(rofi -dmenu -password -theme ~/.config/rofi/wifi.rasi -p "Password for $chosen_ssid")
  [ -z "$password" ] && exit
  nmcli device wifi connect "$chosen_ssid" password "$password"
fi