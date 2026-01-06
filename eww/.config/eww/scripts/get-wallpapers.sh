#!/bin/bash

DIRECTORY=~/wallpapers/
DIRECTORY=$(eval echo $DIRECTORY)

if [ -d "$DIRECTORY" ]; then
        # Buscar archivos regulares Y enlaces simbólicos
        find "$DIRECTORY" \( -type f -o -type l \) \( -name "*.jpg" -o -name "*.png" \) \
                -exec basename {} \; | grep -E '^[0-9]+(\.jpg|\.png)$' | sed -E 's/\.[a-z]+$//' | jq -R 'tonumber' | jq -s .
else
        echo "[]"
        exit 1
fi
