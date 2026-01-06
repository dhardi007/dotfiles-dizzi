#!/bin/bash
# Script: get-dnd-status.sh
# Propósito: Devuelve 'true' o 'false' para el estado del botón toggle en SwayNC.

# El comando swaync-client --get-dnd ya devuelve directamente "true" o "false",
# que es el formato exacto que SwayNC necesita para el estado del botón.

# Nota: En Arch Linux, el ejecutable debería estar en /usr/bin/swaync-client.
/usr/bin/swaync-client --get-dnd
