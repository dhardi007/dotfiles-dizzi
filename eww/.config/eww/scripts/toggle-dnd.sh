#!/bin/bash
# Script de alternancia de No Molestar (DND) solo para SwayNC

# Nota: Usamos la ruta absoluta para mayor fiabilidad.
SWAYNC_CLIENT="/usr/bin/swaync-client"

# 1. Obtener el estado actual de DND (true = ON, false = OFF)
DND_STATUS=$(${SWAYNC_CLIENT} --get-dnd)

if [ "$DND_STATUS" = "true" ]; then
  # DND está activo: lo desactivamos
  ${SWAYNC_CLIENT} --dnd-off
  echo "Notificaciones Reactivadas (DND OFF)"
else
  # DND está inactivo: lo activamos
  ${SWAYNC_CLIENT} --dnd-on
  echo "Notificaciones Pausadas (DND ON)"
fi
