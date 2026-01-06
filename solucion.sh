#!/bin/bash

# ═══════════════════════════════════════════════════════════
# Script de reparación completa de dotfiles
# ═══════════════════════════════════════════════════════════

set -e

echo "🔧 REPARACIÓN COMPLETA DE DOTFILES"
echo "═══════════════════════════════════════════════════════════"

cd ~/dotfiles-dizzi

# ═══════════════════════════════════════════════════════════
# PASO 1: ELIMINAR REFERENCIAS FANTASMA DE ZSH
# ═══════════════════════════════════════════════════════════

echo ""
echo "📝 Paso 1: Limpiando referencias fantasma de zsh..."

# Eliminar del índice Git (sin borrar archivos reales)
git rm --cached -r zsh/.zsh/fzf-tab 2>/dev/null || true
git rm --cached -r zsh/.zsh/zsh-autocomplete 2>/dev/null || true

# Limpiar .git/modules
rm -rf .git/modules/zsh 2>/dev/null || true

# Limpiar config de submódulos
git config --remove-section submodule.zsh/.zsh/fzf-tab 2>/dev/null || true
git config --remove-section submodule.zsh/.zsh/zsh-autocomplete 2>/dev/null || true

echo "✅ Referencias fantasma eliminadas"

# ═══════════════════════════════════════════════════════════
# PASO 2: ARREGLAR .GITIGNORE PARA THEMES
# ═══════════════════════════════════════════════════════════

echo ""
echo "🎨 Paso 2: Corrigiendo .gitignore para themes..."

# Crear backup
cp .gitignore .gitignore.backup

# Eliminar las líneas problemáticas de themes
sed -i '/^themes\/.themes\/\*$/d' .gitignore
sed -i '/^!themes\/.themes\/Gruvbox-Plus-Dark$/d' .gitignore
sed -i '/^!themes\/.themes\/Gruvbox-Plus-Light$/d' .gitignore
sed -i '/^!themes\/.themes\/Colloid-gtk-theme$/d' .gitignore

# Agregar configuración correcta al final
cat >> .gitignore << 'EOL'

# ═══════════════════════════════════════════════════════════
# THEMES - Configuración correcta
# ═══════════════════════════════════════════════════════════
# Bloquear themes/ pero permitir los específicos
themes/.themes/*
!themes/.themes/Gruvbox-Plus-Dark/
!themes/.themes/Gruvbox-Plus-Light/
!themes/.themes/Colloid-gtk-theme/
# Permitir todo dentro de estos directorios
!themes/.themes/Gruvbox-Plus-Dark/**
!themes/.themes/Gruvbox-Plus-Light/**
!themes/.themes/Colloid-gtk-theme/**
EOL

echo "✅ .gitignore corregido"

# ═══════════════════════════════════════════════════════════
# PASO 3: FORZAR AGREGAR THEMES AL REPOSITORIO
# ═══════════════════════════════════════════════════════════

echo ""
echo "📦 Paso 3: Agregando themes al repositorio..."

# Verificar que existen los directorios
if [ -d "themes/.themes/Gruvbox-Plus-Dark" ]; then
    git add -f themes/.themes/Gruvbox-Plus-Dark/
    echo "  ✅ Gruvbox-Plus-Dark agregado"
else
    echo "  ⚠️  Gruvbox-Plus-Dark no existe, se omite"
fi

if [ -d "themes/.themes/Gruvbox-Plus-Light" ]; then
    git add -f themes/.themes/Gruvbox-Plus-Light/
    echo "  ✅ Gruvbox-Plus-Light agregado"
else
    echo "  ⚠️  Gruvbox-Plus-Light no existe, se omite"
fi

if [ -d "themes/.themes/Colloid-gtk-theme" ]; then
    # Colloid es submódulo, verificar .gitmodules
    echo "  ℹ️  Colloid-gtk-theme es submódulo"
else
    echo "  ⚠️  Colloid-gtk-theme no existe"
fi

# Agregar .gitignore modificado
git add .gitignore

echo "✅ Themes agregados"

# ═══════════════════════════════════════════════════════════
# PASO 4: AGREGAR ARCHIVOS ZSH COMO REGULARES (NO SUBMÓDULOS)
# ═══════════════════════════════════════════════════════════

echo ""
echo "🐚 Paso 4: Agregando zsh como archivos regulares..."

# Eliminar .git de los plugins para que no sean submódulos
find zsh/.zsh -name ".git" -type d -exec rm -rf {} + 2>/dev/null || true

# Agregar todo zsh como archivos regulares
git add -f zsh/

echo "✅ Zsh agregado como archivos regulares"

# ═══════════════════════════════════════════════════════════
# PASO 5: COMMIT DE CAMBIOS
# ═══════════════════════════════════════════════════════════

echo ""
echo "💾 Paso 5: Haciendo commit..."

git commit -m "fix: Remove zsh submodule ghosts and add Gruvbox themes

- Remove zsh/.zsh/fzf-tab and zsh-autocomplete submodule references
- Fix .gitignore to properly include Gruvbox themes
- Add zsh plugins as regular files instead of submodules
- Force add Gruvbox-Plus-Dark and Gruvbox-Plus-Light themes"

echo "✅ Commit realizado"

# ═══════════════════════════════════════════════════════════
# PASO 6: ACTUALIZAR SUBMÓDULOS VÁLIDOS
# ═══════════════════════════════════════════════════════════

echo ""
echo "🔄 Paso 6: Actualizando submódulos válidos..."

git submodule sync
git submodule update --init --recursive

echo "✅ Submódulos actualizados"

# ═══════════════════════════════════════════════════════════
# PASO 7: VERIFICACIÓN FINAL
# ═══════════════════════════════════════════════════════════

echo ""
echo "🔍 VERIFICACIÓN FINAL"
echo "═══════════════════════════════════════════════════════════"

echo ""
echo "📊 Estado del repositorio:"
git status

echo ""
echo "📦 Submódulos activos:"
git submodule status

echo ""
echo "🎨 Themes disponibles:"
ls -la themes/.themes/ 2>/dev/null || echo "  ⚠️  Directorio themes/.themes no existe"

echo ""
echo "🐚 Plugins de zsh:"
ls -1 zsh/.zsh/ 2>/dev/null || echo "  ⚠️  Directorio zsh/.zsh no existe"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "✅ REPARACIÓN COMPLETA"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📋 PRÓXIMOS PASOS:"
echo ""
echo "1. Push al repositorio:"
echo "   git push origin main"
echo ""
echo "2. Si falla el push, usar force (CUIDADO):"
echo "   git push origin main --force"
echo ""
echo "3. Aplicar temas con nwg-look:"
echo "   nwg-look"
echo ""
echo "4. Reiniciar zsh:"
echo "   exec zsh"
echo ""
