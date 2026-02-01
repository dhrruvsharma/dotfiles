#!/bin/bash

# Check if Bluetooth is powered on
if bluetoothctl show | grep -q "Powered: yes"; then
    # Try to get the connected device name
    device=$(bluetoothctl info | grep "Name:" | cut -d ' ' -f2-)
    if [ -n "$device" ]; then
        echo " $device"
    else
        echo " On"
    fi
else
    echo " Off"
fi