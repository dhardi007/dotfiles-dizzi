#!/bin/bash

# Revisa si hay un workspace especial activo y si su nombre es "magic"
hyprctl dispatch togglespecialworkspace magic
if hyprctl activeworkspace -j | jq -r '.name' | grep -q 'special:magic'; then
  echo "true"
else
  echo "false"
fi
