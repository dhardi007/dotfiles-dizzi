#!/bin/bash
# Devuelve true si Bluetooth está encendido, false si está apagado
bluetoothctl show | grep -q "Powered: yes" && echo "true" || echo "false"
