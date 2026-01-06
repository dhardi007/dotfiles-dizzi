#!/bin/bash
# ~/scripts/fix-emulator-icons.sh
# Script específico para encontrar y configurar iconos de emuladores

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🎮 Buscador de Iconos de Emuladores${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Lista de emuladores a buscar
EMULATORS=(
  "PCSX2"
  "pcsx2"
  "Citra"
  "citra"
  "Yuzu"
  "yuzu"
  "Ryujinx"
  "ryujinx"
  "tModLoader"
  "terraria"
)

echo -e "${CYAN}🔍 Buscando iconos de emuladores en el sistema...${NC}\n"

found_icons=()

for emu in "${EMULATORS[@]}"; do
  echo -e "${YELLOW}→${NC} Buscando: $emu"

  # Buscar en múltiples ubicaciones
  icon_path=$(find /usr/share/icons /usr/share/pixmaps ~/.local/share/icons ~/.icons \
    -type f \( -iname "*${emu}*.png" -o -iname "*${emu}*.svg" \) 2>/dev/null | head -1)

  if [[ -n "$icon_path" ]]; then
    echo -e "  ${GREEN}✓ Encontrado:${NC} $icon_path"
    found_icons+=("$emu:$icon_path")
  else
    echo -e "  ${RED}✗ No encontrado${NC}"

    # Buscar binarios (puede darnos pistas)
    binary=$(which "$emu" 2>/dev/null || which "${emu,,}" 2>/dev/null)
    if [[ -n "$binary" ]]; then
      echo -e "    ${CYAN}💡 Binario encontrado:${NC} $binary"
      echo -e "    ${YELLOW}Instala el paquete o busca en:${NC}"
      echo -e "       ${CYAN}/opt/${emu,,}${NC}"
      echo -e "       ${CYAN}/usr/share/${emu,,}${NC}"
    fi
  fi
  echo ""
done

# Generar configuración para ICON_MAP
if [[ ${#found_icons[@]} -gt 0 ]]; then
  echo -e "${GREEN}✅ Iconos encontrados (${#found_icons[@]}):${NC}\n"

  echo -e "${CYAN}📋 Agrega esto a tu ICON_MAP en add-icons-to-desktop.sh:${NC}\n"
  echo -e "${YELLOW}declare -A ICON_MAP=(${NC}"

  for entry in "${found_icons[@]}"; do
    emu=$(echo "$entry" | cut -d':' -f1)
    path=$(echo "$entry" | cut -d':' -f2-)
    echo -e "  ${GREEN}[\"$emu\"]=\"$path\"${NC}"
  done

  echo -e "${YELLOW})${NC}\n"
else
  echo -e "${RED}❌ No se encontraron iconos de emuladores${NC}\n"
fi

# Buscar aplicaciones .desktop sin icono
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🔍 Aplicaciones .desktop sin icono válido:${NC}\n"

APPS_DIR="$HOME/.local/share/applications"

for desktop_file in "$APPS_DIR"/*.desktop; do
  [[ ! -f "$desktop_file" ]] && continue

  filename=$(basename "$desktop_file")

  # Verificar si tiene Icon=
  if ! grep -q "^Icon=" "$desktop_file"; then
    echo -e "${RED}✗${NC} $filename ${RED}(sin Icon=)${NC}"
    continue
  fi

  # Obtener ruta del icono
  icon=$(grep "^Icon=" "$desktop_file" | head -1 | cut -d'=' -f2-)

  # Verificar si el icono existe
  if [[ "$icon" == /* ]]; then
    # Ruta absoluta
    if [[ ! -f "$icon" ]]; then
      echo -e "${RED}✗${NC} $filename → ${RED}$icon (no existe)${NC}"
    fi
  else
    # Nombre de icono del tema
    # Buscar si existe en algún directorio estándar
    found=false
    for dir in /usr/share/icons/hicolor/*/apps /usr/share/pixmaps ~/.local/share/icons; do
      if [[ -f "$dir/${icon}.png" ]] || [[ -f "$dir/${icon}.svg" ]]; then
        found=true
        break
      fi
    done

    if ! $found; then
      echo -e "${YELLOW}⚠${NC}  $filename → ${YELLOW}$icon (icono del tema, verificar)${NC}"
    fi
  fi
done

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}💡 Comandos útiles:${NC}\n"
echo -e "  ${CYAN}# Buscar iconos manualmente:${NC}"
echo -e "  find /usr/share/icons -name '*.png' | fzf\n"
echo -e "  ${CYAN}# Ver iconos disponibles:${NC}"
echo -e "  ls -lh /usr/share/pixmaps/ | grep -E '\.(png|svg)'\n"
echo -e "  ${CYAN}# Buscar icono específico:${NC}"
echo -e "  find / -iname '*pcsx2*.png' 2>/dev/null\n"
echo -e "  ${CYAN}# Descargar iconos de emuladores:${NC}"
echo -e "  yay -S pcsx2 # (incluye iconos oficiales)\n"

echo -e "${GREEN}✅ Análisis completado${NC}\n"
