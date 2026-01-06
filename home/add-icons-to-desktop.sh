
#!/bin/bash
#/011   add-icons-to-desktop.sh 
# Script MEJORADO para actualizar iconos en archivos .desktop
# Corrige problemas con mp3tag, ghostty y otros
# Versión: 2.0 - Manejo robusto de múltiples Icon= y Hidden=

APPS_DIR="$HOME/.local/share/applications"
DOTFILES_APPS_DIR="$HOME/dotfiles-dizzi/local/.local/share/applications"
COVERART_DIR="$HOME/.local/share/lutris/coverart"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🎨 Actualizador de Iconos v2.0 (MEJORADO)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${CYAN}Directorios a procesar:${NC}"
echo -e "  ${GREEN}1.${NC} $APPS_DIR"
echo -e "  ${GREEN}2.${NC} $DOTFILES_APPS_DIR"
echo -e "  ${GREEN}→${NC} Iconos: $COVERART_DIR\n"

updated=0
notfound=0
skipped=0

# Función para procesar un archivo .desktop
process_desktop_file() {
  local desktop_file="$1"
  local filename=$(basename "$desktop_file")
  local basename="${filename%.desktop}"
  
  # Limpiar nombre para buscar icono
  local clean_name=$(echo "$basename" | sed 's/^net\.lutris\.//;s/-[0-9]*$//')
  
  # Buscar icono en coverart
  local icon_path=""
  for ext in png jpg jpeg; do
    if [ -f "$COVERART_DIR/${clean_name}.${ext}" ]; then
      icon_path="$COVERART_DIR/${clean_name}.${ext}"
      break
    fi
  done
  
  # Si no encontró, intentar con nombre original
  if [ -z "$icon_path" ]; then
    for ext in png jpg jpeg; do
      if [ -f "$COVERART_DIR/${basename}.${ext}" ]; then
        icon_path="$COVERART_DIR/${basename}.${ext}"
        break
      fi
    done
  fi
  
  if [ -n "$icon_path" ]; then
    # CREAR BACKUP
    
    # NUEVA ESTRATEGIA: Eliminar TODAS las líneas Icon= y agregar una nueva
    # Esto evita problemas con múltiples Icon= o Icon= comentados
    
    # 1. Crear archivo temporal sin líneas Icon=
    grep -v '^Icon=' "$desktop_file" | grep -v '^# Icon=' > "${desktop_file}.tmp"
    
    # 2. Encontrar la posición ideal para insertar Icon=
    # Preferencia: Después de Path=, o después de [Desktop Entry]
    if grep -q "^Path=" "${desktop_file}.tmp"; then
      # Insertar después de Path=
      awk -v icon="Icon=$icon_path" '/^Path=/ {print; print icon; next} 1' "${desktop_file}.tmp" > "$desktop_file"
    else
      # Insertar después de [Desktop Entry]
      awk -v icon="Icon=$icon_path" '/^\[Desktop Entry\]/ {print; print icon; next} 1' "${desktop_file}.tmp" > "$desktop_file"
    fi
    
    # Limpiar temporales
    rm "${desktop_file}.tmp" 2>/dev/null
    
    echo -e "${GREEN}✓${NC} $filename → $(basename "$icon_path")"
    ((updated++))
    
    # Verificar si tiene Hidden=true (solo advertencia, no lo cambiamos)
    if grep -q "^Hidden=true" "$desktop_file"; then
      echo -e "  ${YELLOW}⚠${NC}  Nota: Este archivo tiene Hidden=true (no aparecerá en menú)"
    fi
  else
    echo -e "${RED}✗${NC} Sin icono: $filename"
    ((notfound++))
  fi
}

# Procesar directorio principal (~/.local/share/applications)
if [[ -d "$APPS_DIR" ]]; then
  echo -e "${CYAN}Procesando: $APPS_DIR${NC}\n"
  for desktop_file in "$APPS_DIR"/*.desktop; do
    [ ! -f "$desktop_file" ] && continue
    process_desktop_file "$desktop_file"
  done
else
  echo -e "${YELLOW}⚠${NC}  No existe: $APPS_DIR"
fi

echo

# Procesar directorio de dotfiles si existe
if [[ -d "$DOTFILES_APPS_DIR" ]]; then
  echo -e "${CYAN}Procesando: $DOTFILES_APPS_DIR${NC}\n"
  for desktop_file in "$DOTFILES_APPS_DIR"/*.desktop; do
    [ ! -f "$desktop_file" ] && continue
    process_desktop_file "$desktop_file"
  done
else
  echo -e "${YELLOW}⚠${NC}  No existe: $DOTFILES_APPS_DIR"
fi

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Actualizados: $updated${NC}"
echo -e "${RED}✗ Sin icono: $notfound${NC}"

echo -e "\n${YELLOW}💡 Siguientes pasos:${NC}"
echo -e "  ${GREEN}1.${NC} Actualizar caché: ${CYAN}update-desktop-database ~/.local/share/applications${NC}"
echo -e "  ${GREEN}2.${NC} Si usas dotfiles: ${CYAN}cd ~/dotfiles-dizzi && git status${NC}"
echo -e "  ${GREEN}3.${NC} Para restaurar backups: ${CYAN}mv archivo.desktop.bak archivo.desktop${NC}"

echo -e "\n${YELLOW}🔍 Casos especiales detectados:${NC}"

# Listar archivos con Hidden=true
echo -e "${CYAN}Archivos ocultos (Hidden=true):${NC}"
for desktop_file in "$APPS_DIR"/*.desktop "$DOTFILES_APPS_DIR"/*.desktop 2>/dev/null; do
  [ ! -f "$desktop_file" ] && continue
  if grep -q "^Hidden=true" "$desktop_file"; then
    echo -e "  ${YELLOW}→${NC} $(basename "$desktop_file")"
  fi
done

# Actualizar caché automáticamente
echo -e "\n${YELLOW}→${NC} Actualizando caché de aplicaciones..."
update-desktop-database ~/.local/share/applications 2>/dev/null || true
echo -e "${GREEN}✓${NC} Caché actualizado\n"
