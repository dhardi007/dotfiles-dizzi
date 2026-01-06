#!/bin/bash
# ~/scripts/git_clean.sh - Con selector de repositorio

# ============================================
# 1. SELECCIONAR REPOSITORIO
# ============================================

# Repositorio por defecto
DEFAULT_REPO="$HOME/dotfiles-dizzi"

# Lista de repositorios comunes (agrega los tuyos aquí)
REPOS=(
  "$HOME/dotfiles-dizzi"
  "$HOME/dotfiles-dizzi/nvim/.config/nvim/"
  "$HOME/dotfiles-wsl-dizzi"
  "$HOME/dotfiles-dizzi/nvim-wsl/.config/nvim/"
  "$HOME/workspace"
  "$HOME/workspace/GLAZE-WM-make-windows-pretty-main-dizzi"
  "$HOME/workspace/Proyecto-App-MCSD"
  "$HOME/workspace/REACT-Diego-Dizzi-Dashboard"
  "$HOME/workspace/portfolio-terminal-dhardi"
  "$HOME/workspace/Librezam"
  "$HOME/workspace/FCTicService.github.6c-Diego-05"
  "$HOME/workspace/FCTicService.github.6c-Diego-05"
  "$(pwd)" # Directorio actual
)

# Construir menú de repos existentes
REPO_MENU=""
for repo in "${REPOS[@]}"; do
  # Verificar si es un repo git válido
  if [[ -d "$repo/.git" ]]; then
    REPO_NAME=$(basename "$repo")
    REPO_MENU+="󰊢  $REPO_NAME ($repo)\n"
  fi
done

# Agregar opción para escribir ruta manualmente
REPO_MENU+="  Escribir ruta manualmente"

# Mostrar menú de selección
SELECTED_REPO=$(echo -e "$REPO_MENU" | rofi -dmenu -p "Seleccionar Repositorio" -config ~/.config/rofi/config-power-grid.rasi -theme-str 'window {width: 1000px; height: 400px;} listview {columns: 3; spacing: 20px;} element {min-width: 260px; padding: 35px 30px;}')

# Si canceló, salir
[[ -z "$SELECTED_REPO" ]] && exit 0

# Extraer ruta del repo seleccionado
if [[ "$SELECTED_REPO" == *"Escribir ruta"* ]]; then
  # Pedir ruta manualmente
  REPO_PATH=$(rofi -dmenu -p "Ruta del repositorio" -config ~/.config/rofi/config-power-grid.rasi)
  [[ -z "$REPO_PATH" ]] && exit 0
else
  # Extraer ruta del paréntesis
  REPO_PATH=$(echo "$SELECTED_REPO" | grep -oP '\(.*?\)' | tr -d '()')
fi

# Expandir ~ a $HOME
REPO_PATH="${REPO_PATH/#\~/$HOME}"

# Verificar que sea un repo git válido
if [[ ! -d "$REPO_PATH/.git" ]]; then
  notify-send -u critical "Git Clean" "❌ '$REPO_PATH' no es un repositorio Git válido"
  exit 1
fi

# Cambiar al directorio del repo
cd "$REPO_PATH" || exit 1

# Notificar repo seleccionado
REPO_NAME=$(basename "$REPO_PATH")
notify-send "Git Clean" "📂 Repositorio actual: $REPO_NAME\n📁 $REPO_PATH"

# ============================================
# 2. SELECCIONAR ACCIÓN
# ============================================

ACTION=$(printf "  Limpieza normal\n  Limpieza profunda\n󰈈  Ver espacio\n󰚰  Filter-Repo\n󰈛  Eliminar historial" | rofi -dmenu -p "Git Clean" -config ~/.config/rofi/config-power-grid.rasi -theme-str 'window {width: 1400px; height: 300px;} listview {columns: 3; spacing: 20px;} element {min-width: 260px; padding: 35px 30px;}')

# Si canceló, salir
[[ -z "$ACTION" ]] && exit 0

# ============================================
# 3. EJECUTAR ACCIÓN SELECCIONADA
# ============================================

case "$ACTION" in
*"Limpieza normal"*)
  kitty -e bash -c "
      cd '$REPO_PATH'
      echo '📂 Repositorio: $REPO_NAME'
      echo '📁 Ruta: $REPO_PATH'
      echo ''
      echo 'Limpiando repositorio...'
      git gc --prune=now
      echo ''
      echo '✓ Limpieza completada'
      read -p 'Presiona Enter para cerrar'
    "
  notify-send "Git" "✅ Limpieza normal completada en $REPO_NAME"
  ;;

*"Limpieza profunda"*)
  kitty -e bash -c "
      cd '$REPO_PATH'
      echo '📂 Repositorio: $REPO_NAME'
      echo '📁 Ruta: $REPO_PATH'
      echo ''
      echo 'Iniciando limpieza profunda...'
      git reflog expire --expire=now --all
      git gc --prune=now --aggressive
      git repack -a -d --depth=50 --window=250
      echo ''
      echo '✓ Limpieza profunda completada'
      read -p 'Presiona Enter para cerrar'
    "
  notify-send "Git" "✅ Limpieza profunda completada en $REPO_NAME"
  ;;

*"Ver espacio"*)
  kitty -e bash -c "
      cd '$REPO_PATH'
      echo '📂 Repositorio: $REPO_NAME'
      echo '📁 Ruta: $REPO_PATH'
      echo ''
      echo '=== Espacio usado por Git ==='
      git count-objects -vH
      echo ''
      echo '=== Archivos grandes ==='
      git rev-list --objects --all |
        git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
        awk '/^blob/ {print \$3, \$4}' |
        sort -n -r |
        head -20 |
        numfmt --to=iec-i --suffix=B --field=1 --padding=7
      echo ''
      echo '=== Tamaño del repositorio ==='
      du -sh .git
      read -p 'Presiona Enter para cerrar'
    "
  ;;

*"Filter-Repo"*)
  FILTER_CHOICE=$(printf "󰨞  Instalar filter-repo\n󰚰  Limpiar archivos grandes\n󰙆  Limpiar logs (*.log)\n󱁤  Limpiar temporales\n󰩺  Limpiar carpeta específica\n󰙴  Limpiar extensión específica" | rofi -dmenu -p "Filter-Repo" -config ~/.config/rofi/config-power-grid.rasi -theme-str 'window {width: 800px; height: 400px;}')

  case "$FILTER_CHOICE" in
  *"Instalar filter-repo"*)
    kitty -e bash -c "
          echo 'Instalando git-filter-repo...'
          pip install git-filter-repo
          echo ''
          echo '✓ git-filter-repo instalado'
          read -p 'Presiona Enter para cerrar'
        "
    notify-send "Git" "git-filter-repo instalado"
    ;;

  *"Limpiar archivos grandes"*)
    kitty -e bash -c "
          cd '$REPO_PATH'
          echo '📂 Repositorio: $REPO_NAME'
          echo ''
          echo '=== Archivos más grandes (top 10) ==='
          git rev-list --objects --all |
            git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
            awk '/^blob/ {print \$3, \$4}' |
            sort -n -r |
            head -10 |
            numfmt --to=iec-i --suffix=B --field=1 --padding=7
          echo ''
          read -p 'Ingresa el tamaño mínimo a eliminar (ej: 10M, 100K): ' SIZE
          
          if [[ -n \$SIZE ]]; then
              echo ''
              echo 'Creando backup en .git.backup...'
              cp -r .git .git.backup
              
              echo 'Eliminando archivos mayores a \$SIZE...'
              git filter-repo --strip-blobs-bigger-than \$SIZE --force
              
              echo ''
              echo '✓ Archivos grandes eliminados'
              echo '⚠️  Ejecuta: git push --force --all'
              echo '💾 Backup disponible en: .git.backup'
          fi
          
          read -p 'Presiona Enter para cerrar'
        "
    notify-send "Git" "Archivos grandes eliminados de $REPO_NAME"
    ;;

  *"Limpiar logs"*)
    kitty -e bash -c "
          cd '$REPO_PATH'
          echo '📂 Repositorio: $REPO_NAME'
          echo ''
          echo 'Limpiando archivos .log del historial...'
          git filter-repo --path-glob '*.log' --invert-paths --force
          echo ''
          echo '✓ Logs eliminados del historial'
          echo '⚠️  Ejecuta: git push --force --all'
          read -p 'Presiona Enter para cerrar'
        "
    notify-send "Git" "Logs eliminados de $REPO_NAME"
    ;;

  *"Limpiar temporales"*)
    kitty -e bash -c "
          cd '$REPO_PATH'
          echo '📂 Repositorio: $REPO_NAME'
          echo ''
          echo 'Limpiando archivos temporales...'
          git filter-repo \
            --path-glob 'tmp/*' \
            --path-glob 'temp/*' \
            --path-glob '*.tmp' \
            --path-glob '*.cache' \
            --path-glob '__pycache__/*' \
            --path-glob 'node_modules/*' \
            --invert-paths --force
          echo ''
          echo '✓ Archivos temporales eliminados'
          echo '⚠️  Ejecuta: git push --force --all'
          read -p 'Presiona Enter para cerrar'
        "
    notify-send "Git" "Temporales eliminados de $REPO_NAME"
    ;;

  *"Limpiar carpeta específica"*)
    FOLDER=$(rofi -dmenu -p "Carpeta a eliminar (ej: logs/, temp/)" -config ~/.config/rofi/config-power-grid.rasi)
    if [[ -n "$FOLDER" ]]; then
      kitty -e bash -c "
            cd '$REPO_PATH'
            echo '📂 Repositorio: $REPO_NAME'
            echo ''
            echo 'Eliminando carpeta: $FOLDER'
            git filter-repo --path '$FOLDER' --invert-paths --force
            echo ''
            echo '✓ Carpeta $FOLDER eliminada del historial'
            echo '⚠️  Ejecuta: git push --force --all'
            read -p 'Presiona Enter para cerrar'
          "
      notify-send "Git" "Carpeta '$FOLDER' eliminada de $REPO_NAME"
    fi
    ;;

  *"Limpiar extensión específica"*)
    EXT=$(rofi -dmenu -p "Extensión a eliminar (ej: *.mp4, *.zip)" -config ~/.config/rofi/config-power-grid.rasi)
    if [[ -n "$EXT" ]]; then
      kitty -e bash -c "
            cd '$REPO_PATH'
            echo '📂 Repositorio: $REPO_NAME'
            echo ''
            echo 'Eliminando archivos: $EXT'
            git filter-repo --path-glob '$EXT' --invert-paths --force
            echo ''
            echo '✓ Archivos $EXT eliminados del historial'
            echo '⚠️  Ejecuta: git push --force --all'
            read -p 'Presiona Enter para cerrar'
          "
      notify-send "Git" "Extensión '$EXT' eliminada de $REPO_NAME"
    fi
    ;;
  esac
  ;;

*"Eliminar historial"*)
  RESPONSE=$(printf "󰩖  Cancelar\n󰚮  Continuar (DESTRUCTIVO)" | rofi -dmenu -p "⚠️ ¿Eliminar TODO el historial de $REPO_NAME?" -config ~/.config/rofi/config-power-grid.rasi -theme-str 'window {width: 600px;}')

  if [[ "$RESPONSE" == *"Continuar"* ]]; then
    kitty -e bash -c "
        cd '$REPO_PATH'
        echo '📂 Repositorio: $REPO_NAME'
        echo ''
        echo '⚠️  ADVERTENCIA: Eliminando TODO el historial'
        echo ''
        
        # Detectar rama actual
        CURRENT_BRANCH=\$(git branch --show-current)
        echo 'Rama actual: \$CURRENT_BRANCH'
        echo ''
        
        # Crear nueva rama huérfana
        git checkout --orphan new-\$CURRENT_BRANCH
        git add -A
        git commit -m 'Fresh start - Historia reiniciada'
        
        # Eliminar rama vieja
        git branch -D \$CURRENT_BRANCH
        
        # Renombrar nueva rama
        git branch -m \$CURRENT_BRANCH
        
        echo ''
        echo '✓ Historial eliminado'
        echo ''
        echo '⚠️  SIGUIENTE PASO:'
        echo 'git push -u origin \$CURRENT_BRANCH --force'
        echo ''
        read -p 'Presiona Enter para cerrar'
      "
    notify-send "Git" "⚠️ Historial eliminado de $REPO_NAME\nListo para push --force"
  fi
  ;;
esac
