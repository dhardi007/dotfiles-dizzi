#!/bin/bash
networkmanager_dmenu
sh -c 'nmcli device wifi list | tail -n +2 | rofi -dmenu -p "Seleccionar Red:" -config ~/.config/rofi/config-power.rasi'
