#!/bin/bash
# ~/scripts/crear_escritorio-CustomRP.sh
# =================================================================================
# MÉTODO 2: LUTRIS - Exportar apps + iconos sueltos
# TODO DIRECTO, SIN CARPETAS
# =================================================================================
/home/diego/scripts/crear_escritorio-CustomRP.sh
/home/diego/add-icons-to-desktop.sh
ESCRITORIO="/home/diego/Escritorio"
# DOCUMENTOS="/home/diego/Documentos"
WINEDOCUMENTOS="/home/diego/.wine/drive_c/users/diego/Desktop" # Para CustomRP .crp SUELTOS
GDRIVE_ICONS="/home/diego/mi_gdrive/Mi unidad/[Documentos]/[Iconos - Status personalizados DISCORD CustomRP]"

echo "🚀 MÉTODO 2: LUTRIS DIRECTO"
echo "================================================"

# 1. LIMPIAR
echo "1. Limpiando..."
rm -f "$ESCRITORIO"/*.desktop 2>/dev/null
rm -f "$ESCRITORIO"/*.png "$ESCRITORIO"/*.jpg 2>/dev/null
rm -f "$WINEDOCUMENTOS"/*.crp 2>/dev/null

for slug in "${LUTRIS_SLUGS[@]}"; do
  echo -n "   $slug... "
  if lutris --export "$slug" --dest "$ESCRITORIO" 2>/dev/null; then
    echo "✓"
  else
    echo "✗"
  fi
done
# 5. COPIAR .crp SUELTOS A WINEDOCUMENTOS
echo "5. Copiando .crp SUELTOS a Documentos..."
if [ -d "$GDRIVE_ICONS" ]; then
  find "$GDRIVE_ICONS" -type f -name "*.crp" | head -10 | while read crp; do
    cp "$crp" "$ESCRITORIO/"
    echo "   ✓ $(basename "$crp")"
  done
fi

# 6. PREPARAR WINE (para CustomRP)
echo "6. Preparando Wine..."
WINE_DIR="$HOME/.wine/drive_c/CustomRP_Icons"
rm -rf "$WINE_DIR"
mkdir -p "$WINE_DIR"
if [ -d "$GDRIVE_ICONS" ]; then
  # Copiar TODO para Wine (aquí sí carpeta, porque Wine lo necesita)
  cp -r "$GDRIVE_ICONS"/* "$WINE_DIR/" 2>/dev/null
  echo "   ✓ Wine listo con $(ls -1 "$WINE_DIR" | wc -l) archivos"
fi

# 7. RESUMEN
echo ""
echo "✅ MÉTODO 2 COMPLETADO"
echo "====================="
echo "Escritorio tiene:"
find "$ESCRITORIO" -maxdepth 1 -type f -name "*.desktop" | wc -l | xargs echo "  • Apps:"
echo ""
echo "Documentos tiene:"
find "$WINEDOCUMENTOS" -maxdepth 1 -type f -name "*.crp" | wc -l | xargs echo "  • .crp:"
