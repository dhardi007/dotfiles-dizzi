#!/bin/bash

# Si se hace click, abrir en kitty + nvim
if [ "$1" = "click" ]; then
  generate_clean_updates() {
    cat >/tmp/updates <<'EOF'
╔══════════════════════════════════════════════════╗
║             ACTUALIZACIONES PENDIENTES           ║
╚══════════════════════════════════════════════════╝

EOF

    # Arch updates - solo si hay actualizaciones
    if checkupdates &>/dev/null; then
      arch_updates=$(checkupdates 2>/dev/null)
      arch_count=$(echo "$arch_updates" | wc -l)
      echo "🔄 ARCH LINUX ($arch_count paquetes)" >>/tmp/updates
      echo "──────────────────────────────────────────────────────" >>/tmp/updates
      echo "$arch_updates" | sed 's/^/  • /' >>/tmp/updates
      echo "" >>/tmp/updates
    else
      echo "✅ ARCH: Actualizado" >>/tmp/updates
      echo "" >>/tmp/updates
    fi

    # AUR updates - solo si hay actualizaciones
    if yay -Qum &>/dev/null; then
      aur_updates=$(yay -Qum 2>/dev/null)
      aur_count=$(echo "$aur_updates" | wc -l)
      echo "📦 AUR ($aur_count paquetes)" >>/tmp/updates
      echo "──────────────────────────────────────────────────────" >>/tmp/updates
      echo "$aur_updates" | sed 's/^/  • /' >>/tmp/updates
      echo "" >>/tmp/updates
    else
      echo "✅ AUR: Actualizado" >>/tmp/updates
      echo "" >>/tmp/updates
    fi

    # Resumen
    total=$((arch_count + aur_count))
    echo "══════════════════════════════════════════════════" >>/tmp/updates
    echo "📊 TOTAL: $total paquetes pendientes" >>/tmp/updates
    echo "🕐 Actualizado: $(date '+%Y-%m-%d %H:%M:%S')" >>/tmp/updates
  }

  generate_clean_updates
  kitty nvim /tmp/updates +"set filetype=text" +"set wrap" +"set linebreak" +"set number" +"syntax off" +"normal gg"
  exit 0
fi

# ============================================================================
# CÓDIGO ORIGINAL PARA WAYBAR (corregido)
# ============================================================================

format() {
  if [ "$1" -eq 0 ]; then
    echo '-'
  else
    echo "$1"
  fi
}

# Conteo de actualizaciones
updates_arch=$(checkupdates 2>/dev/null | tee /tmp/arch_updates.txt | wc -l)
updates_aur=$(yay -Qum 2>/dev/null | tee /tmp/aur_updates.txt | wc -l)
updates_total=$((updates_arch + updates_aur))

# Icono y color según updates
if [ "$updates_total" -gt 0 ]; then
  icon=""
  color="#FF5555"
else
  icon=""
  color="#50FA7B"
fi

# Obtener página actual y cambiar automáticamente
PAGE_FILE="/tmp/waybar_updates_page"
[ -f "$PAGE_FILE" ] || echo "0" >"$PAGE_FILE"
page=$(cat "$PAGE_FILE")

# 50 paquetes por página
items_per_page=50

# Leer archivos y crear arrays
mapfile -t arch_array </tmp/arch_updates.txt
mapfile -t aur_array </tmp/aur_updates.txt

# Validar páginas
max_arch_pages=$(((updates_arch + items_per_page - 1) / items_per_page))
max_aur_pages=$(((updates_aur + items_per_page - 1) / items_per_page))
total_pages=$((max_arch_pages + max_aur_pages))

# Cambio automático cada 3 segundos
current_time=$(date +%s)
last_change_file="/tmp/waybar_last_change"
[ -f "$last_change_file" ] || echo "$current_time" >"$last_change_file"
last_change=$(cat "$last_change_file")

if [ $((current_time - last_change)) -ge 3 ]; then
  page=$(((page + 1) % total_pages))
  echo "$page" >"$PAGE_FILE"
  echo "$current_time" >"$last_change_file"
fi

# Resetear página si es necesario
if [ "$page" -ge "$total_pages" ] || [ "$page" -lt 0 ]; then
  page=0
  echo "0" >"$PAGE_FILE"
fi

# Determinar qué sección mostrar (Arch o AUR)
if [ "$page" -lt "$max_arch_pages" ]; then
  # Mostrar página de Arch
  section_name="Arch"
  section_array=("${arch_array[@]}")
  section_total=$updates_arch
  section_page=$page
  all_page=$((page + 1))
else
  # Mostrar página de AUR
  section_name="AUR"
  section_array=("${aur_array[@]}")
  section_total=$updates_aur
  section_page=$((page - max_arch_pages))
  all_page=$((page + 1))
fi

# Obtener items de la página actual
start=$((section_page * items_per_page))
end=$((start + items_per_page))
page_items=("${section_array[@]:$start:$items_per_page}")

# Crear tooltip formateado (SIN ESPACIOS NECESARIOS)
section_pages=$(((section_total + items_per_page - 1) / items_per_page))
header_text="$section_name [$((section_page + 1))/$section_pages]"

tooltip_text="╔════════════════════════════╗"$'\n'
tooltip_text+="║ $header_text ║"$'\n'
tooltip_text+="╚════════════════════════════╝"$'\n'

for item in "${page_items[@]}"; do
  [ -n "$item" ] && tooltip_text+="  • $item"$'\n'
done

tooltip_text+=$'\n'"• • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • • •"$'\n'
tooltip_text+="Página global: $all_page/$total_pages  ║ 「」 Auto-cambio cada 3s"$'\n'

# Escapar tooltip para JSON
tooltip_escaped=$(python3 -c "import json,sys; print(json.dumps('''$tooltip_text'''))")

# Salida JSON para Waybar
echo "{\"text\":\"$icon $updates_total\",\"tooltip\":$tooltip_escaped,\"class\":\"custom-updates\",\"color\":\"$color\"}"
