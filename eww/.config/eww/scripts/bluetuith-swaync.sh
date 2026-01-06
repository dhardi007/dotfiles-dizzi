#!/bin/bash

# Cerrar swaync completamente
swaync-client -cp

# Pausa
sleep 0.3

# Tu lógica de bluetooth aquí...
if hyprctl clients | grep -q "class: bluetooth"; then
  hyprctl dispatch focuswindow "class:bluetooth"
else
  hyprctl dispatch exec "[float; size 525 260; center; pin] kitty --class bluetooth bluetoothctl"
  sleep 0.5
  hyprctl dispatch focuswindow "class:bluetooth"
fi
