#!/bin/bash
#/005   wifi-toggle.sh
# Script de toggle WiFi para Arch con NetworkManager

if nmcli radio wifi | grep -q enabled; then
  nmcli radio wifi off
  notify-send "󰖪 WiFi Desactivado" "Red inalámbrica desconectada" -i network-wireless-offline-symbolic -u normal
else
  nmcli radio wifi on
  notify-send "󰤨 WiFi Activado" "Red inalámbrica conectada" -i network-wireless-signal-good-symbolic -u normal
fi
