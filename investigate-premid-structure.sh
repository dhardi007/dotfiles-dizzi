#!/bin/bash
# investigate-premid-structure.sh

echo "🔍 Investigando PreMiD en tu sistema..."

# 1. Verificar extensión
EXT_DIR="$HOME/.mozilla/firefox/d7x1olml.default-release/extensions"
if [[ -f "$EXT_DIR/support@premid.app.xpi" ]]; then
  echo "✅ Extensión encontrada:"
  ls -lh "$EXT_DIR/support@premid.app.xpi"
fi

# 2. Buscar datos de extensión
echo ""
echo "📂 Buscando datos de extensión..."
find ~/.mozilla/firefox/d7x1olml.default-release/storage/default -name "*premid*" -type d 2>/dev/null

# 3. Buscar en extension-store
echo ""
echo "📦 Buscando en extension-store..."
ls -la ~/.mozilla/firefox/d7x1olml.default-release/extension-store/ 2>/dev/null | grep -i premid

# 4. Buscar bases de datos IndexedDB
echo ""
echo "💾 Bases de datos IndexedDB:"
find ~/.mozilla/firefox/d7x1olml.default-release/storage/default -name "*.sqlite" 2>/dev/null | while read db; do
  if sqlite3 "$db" ".tables" 2>/dev/null | grep -qi "presence\|premid"; then
    echo "  Encontrada: $db"
  fi
done

# 5. Buscar archivos JSON con configuración
echo ""
echo "📄 Archivos de configuración:"
find ~/.mozilla/firefox/d7x1olml.default-release -name "*.json" -type f 2>/dev/null | while read json; do
  if grep -qi "premid\|presence" "$json" 2>/dev/null; then
    echo "  $json"
  fi
done
