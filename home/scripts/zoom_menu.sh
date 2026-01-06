#!/bin/bash

MONITOR="eDP-1"
# Usamos Wofi con un prompt (título) más claro
LAUNCHER="wofi --show dmenu -i --prompt '🔍 Seleccionar Nivel de Zoom'"

# Definir las opciones del menú de zoom con emojis para claridad.
# El formato sigue siendo "ESCALA | DESCRIPCIÓN"
OPTIONS="\
1.0 | 🔄 Restablecer (Normal)
1.2 | 🔻 Zoom Out Extremo (Muy pequeño)
1.5 | ⬆️ Zoom In Suave (Cómodo)
2.0 | ➕ Zoom In Medio (Acercar)
2.5 | ⏫ Zoom In Fuerte (Accesibilidad)
3.0 | 🔎 Zoom In Extremo (Máxima Lupa)"

# --- Lógica de Wofi/dmenu ---

# Usar el lanzador para que el usuario seleccione una opción.
# Rofi/Wofi recibirán las opciones formateadas.
CHOICE=$(echo -e "$OPTIONS" | $LAUNCHER | awk '{print $1}')

# Si el usuario seleccionó una opción
if [ -n "$CHOICE" ]; then
  # Extraer el valor numérico de la escala (el primer campo, antes del pipe o espacio)
  # Usamos awk y tr para obtener solo el número
  SCALE=$(echo "$CHOICE" | awk '{print $1}')

  # Aplicar el nuevo valor de escala usando hyprctl
  hyprctl keyword monitor "$MONITOR,preferred,auto,$SCALE"

  # Notificación de confirmación
  notify-send "🔍 Zoom Aplicado" "Escala: $SCALE en $MONITOR"
fi
