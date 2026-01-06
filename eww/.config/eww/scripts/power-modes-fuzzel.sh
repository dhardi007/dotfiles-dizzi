#!/bin/zsh
# ~/.config/eww/scripts/power-modes-fuzzel.sh

# Estados
BLUR_STATE="/tmp/hypr_blur_disabled"
GAME_STATE="/tmp/hypr_game_mode"

# Check Blur State
IS_BLUR_ENABLED=$(hyprctl getoption decoration:blur:enabled | awk '/int:/ {print $2}')

if [[ "$IS_BLUR_ENABLED" == "1" ]]; then
    BLUR_OPTION="󰂷󰈈 Desactivar Blur"
else
    BLUR_OPTION="󰂵󰂵 Activar Blur"
fi

GAME_SCRIPT="$HOME/.config/eww/scripts/toggle-game-mode.sh"

# Función helper
game_off() { [[ -f "$GAME_STATE" ]] && bash "$GAME_SCRIPT" off; }

# Menú
CHOICE=$(fuzzel --dmenu --prompt="Modos de Energía:" <<< \
"󰂄 Modo Ahorro (Low Power)
󰗑 Modo Equilibrado (Balanced)
󱓞 Modo Juego (Performance)
$BLUR_OPTION
🔄 RESET Total" 2>/dev/null)

[[ -z "$CHOICE" ]] && exit 0

# Lógica
case "$CHOICE" in
    *"Modo Ahorro"*)
        game_off
        powerprofilesctl set power-saver
        eww update power-mode-icon="󰂄"
        cpupower frequency-set -g powersave
        notify-send "󰂄 Modo Ahorro Activo" "Energía optimizada"
        ;;

    *"Modo Equilibrado"*)
        game_off
        powerprofilesctl set balanced
        eww update power-mode-icon=""
        notify-send " Modo Equilibrado" "Configuración normal"
        ;;

    *"Modo Juego"*)
        bash "$GAME_SCRIPT"

        if [[ -f "$GAME_STATE" ]]; then
            powerprofilesctl set performance
            cpupower frequency-set -g performance
            eww update power-mode-icon=""
        else
            powerprofilesctl set balanced
            eww update power-mode-icon=""
        fi
        ;;

    *"Blur"*)
        if [[ "$IS_BLUR_ENABLED" == "1" ]]; then
            hyprctl keyword decoration:blur:enabled false
            rm "$BLUR_STATE" 2>/dev/null
            notify-send "󰈈 Blur Desactivado" "Modo por defecto"
        else
            hyprctl keyword decoration:blur:enabled true
            touch "$BLUR_STATE"
            notify-send "󰈈 Blur Activado" "Experimental"
        fi
        ;;

    *"RESET"*)
        game_off
        [[ -f "$BLUR_STATE" ]] && hyprctl keyword decoration:blur:enabled false && rm "$BLUR_STATE"
        powerprofilesctl set balanced
        hyprctl reload
        eww update power-mode-icon=""
        notify-send "🔄 Sistema Reseteado" "Configuración por defecto"
        ;;
esac

