#!/bin/bash

# ~/scripts/git_clean.sh

echo "Seleccionar acción de limpieza:"

ACTION=$(printf "  Limpieza normal\n  Limpieza profunda\n󰈈  Ver espacio\n󰚰  Filter-Repo\n󰈛  Eliminar historial" | rofi -dmenu -p "Git Clean" -config ~/.config/rofi/config-power-grid.rasi -theme-str 'window {width: 1400px; height: 300px;} listview {columns: 3; spacing: 20px;} element {min-width: 260px; padding: 35px 30px;}')

cd ~/dotfiles-dizzi

case "$ACTION" in
*"Limpieza normal"*)
  kitty -e bash -c "
      echo 'Limpiando repositorio...'
      git gc --prune=now
      echo '✓ Limpieza completada'
      read -p 'Presiona Enter para cerrar'
    "
  notify-send "Git" "Limpieza normal completada"
  ;;

*"Limpieza profunda"*)
  kitty -e bash -c "
      echo 'Iniciando limpieza profunda...'
      git reflog expire --expire=now --all
      git gc --prune=now --aggressive
      git repack -a -d --depth=50 --window=250
      echo '✓ Limpieza profunda completada'
      read -p 'Presiona Enter para cerrar'
    "
  notify-send "Git" "Limpieza profunda completada"
  ;;

*"Ver espacio"*)
  kitty -e bash -c "
      echo '=== Espacio usado por Git ==='
      git count-objects -vH
      echo ''
      echo '=== Archivos grandes ==='
      git rev-list --objects --all |
        git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
        awk '/^blob/ {print \$3, \$4}' |
        sort -n -r |
        head -20
      read -p 'Presiona Enter para cerrar'
    "
  ;;

*"Filter-Repo"*)
  FILTER_CHOICE=$(printf "󰨞  Instalar filter-repo\n󰚰  Limpiar todo\n󰙆  Limpiar logs\n󱁤  Limpiar temporales" | rofi -dmenu -p "Filter-Repo")

  case "$FILTER_CHOICE" in
  *"Instalar filter-repo"*)
    kitty -e bash -c "
          pip install git-filter-repo
          echo '✓ git-filter-repo instalado'
          read -p 'Presiona Enter para cerrar'
        "
    ;;

  *"Limpiar todo"*)
    kitty -e bash -c "
          echo 'ATENCIÓN: Esto eliminará todo el historial'
          echo 'Creando copia de seguridad primero...'
          cp -r .git .git.backup
          echo 'Ejecutando filter-repo...'
          git filter-repo --path . --invert-paths
          echo '✓ Historial limpiado'
          echo 'Si algo sale mal: rm -rf .git && mv .git.backup .git'
          read -p 'Presiona Enter para cerrar'
        "
    ;;

  *"Limpiar logs"*)
    kitty -e bash -c "
          echo 'Limpiando archivos .log del historial...'
          git filter-repo --path-glob '*.log' --force
          echo '✓ Logs eliminados del historial'
          read -p 'Presiona Enter para cerrar'
        "
    ;;

  *"Limpiar temporales"*)
    kitty -e bash -c "
          echo 'Limpiando archivos temporales...'
          git filter-repo --path-glob 'tmp/*' --path-glob 'temp/*' --path-glob '*.tmp' --force
          echo '✓ Archivos temporales eliminados'
          read -p 'Presiona Enter para cerrar'
        "
    ;;
  esac
  notify-send "Git" "Filter-Repo completado"
  ;;

*"Eliminar historial"*)
  RESPONSE=$(printf "󰩖  Cancelar\n󰚮  Continuar" | rofi -dmenu -p "¿Eliminar todo el historial?")

  if [[ "$RESPONSE" == *"Continuar"* ]]; then
    kitty -e bash -c "
        git checkout --orphan new-main
        git add -A
        git commit -m 'Fresh start'
        git branch -D main
        git branch -m main
        echo '✓ Historial eliminado'
        echo 'Ejecuta: git push -u origin main --force'
        read -p 'Presiona Enter para cerrar'
      "
    notify-send "Git" "Historial eliminado, listo para push --force"
  fi
  ;;
esac
