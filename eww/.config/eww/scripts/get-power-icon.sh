#!/bin/zsh
# Devuelve el icono basado en el perfil de energía activo.

# 1. Obtener el perfil activo (Ej: power-saver, balanced, performance)
ACTIVE_PROFILE=$(powerprofilesctl get)

# 2. Devolver el icono correspondiente
case "$ACTIVE_PROFILE" in
    power-saver)
        # Modo Ahorro (Low Power)
        echo "󰂄"
        ;;
    balanced)
        # Modo Equilibrado (Balanced)
        echo ""
        ;;
    performance)
        # Modo Juego/Rendimiento (Performance/Optimized)
        echo ""
        ;;
    *)
        # Fallback (Icono de batería genérico si falla)
        echo "󱊡"
        ;;
esac
