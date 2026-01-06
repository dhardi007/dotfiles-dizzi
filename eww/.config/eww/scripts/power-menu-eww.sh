#!/bin/bash
# Wrapper específico para EWW

export WAYLAND_DISPLAY="wayland-1"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

exec ~/.config/eww/scripts/power-modes-fuzzel.sh
