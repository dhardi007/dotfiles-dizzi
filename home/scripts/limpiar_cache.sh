#!/bin/bash
# Script interactivo para limpiar caché y dependencias en Arch Linux + yay

while true; do
  clear
  echo "⚙️ Limpiar caché y dependencias - MENÚ"
  echo "-------------------------------------"
  echo "1) Limpiar caché de pacman 󰮯 (sudo)"
  echo "2) Eliminar dependencias huérfanas de pacman 󰮯 (sudo)"
  echo "3) Limpiar caché y dependencias huérfanas de yay "
  echo "4) Limpiar caches de  npm/yarn/pnpm 󰎙 "
  echo "5) Limpiar ~/.cache completo 󰃨"
  echo "6) Limpiar caché de neovim "
  echo "7) 󰀧[PELIGRO!!!]󰀦 Reinstalar Plugins de Neovim (depurar/downgrade) ♻️"
  echo "8) Salir 󰩈"
  echo "-------------------------------------"
  read -rp "Selecciona una opción: " opcion

  case $opcion in
  1)
    echo "Limpiando caché de pacman..."
    sudo pacman -Scc
    notify-send "🗑️ PACMAN Cache" 'Recuerda reaplicar fondos y ajustar QT5/QT6, lxa y nwglook  🎨'
    ;;
  2)
    echo "Eliminando dependencias huérfanas de pacman..."
    sudo pacman -Rns $(pacman -Qdtq)
    notify-send "🗑️ Pacman Huérfanas" 'Recuerda reaplicar fondos y ajustar QT5/QT6, lxa y nwglook  🎨'
    ;;
  3)
    echo "Eliminando dependencias huérfanas y caché de yay..."
    yay -Scc
    rm -rf ~/.cache/yay
    yay -Rns $(yay -Qdtq)
    notify-send "🗑️ YAY Cache" 'Recuerda reaplicar fondos y ajustar QT5/QT6, lxa y nwglook  🎨'
    ;;
  4)
    echo "Limpiando pnpm, npm y yarn..."
    pnpm store prune
    npm cache clean --force
    yarn cache clean
    notify-send "🗑️ NPM Cache" 'Recuerda reaplicar fondos y ajustar QT5/QT6, lxa y nwglook  🎨'
    ;;
  5)
    echo "Limpiando ~/.cache completo..."
    rm -rf ~/.cache/*
    notify-send "🗑️ CACHE COMPLETO" 'Recuerda reaplicar fondos y ajustar QT5/QT6, lxa y nwglook  🎨'
    ;;
  6)
    echo "Limpiando caché de neovim..."
    rm -rf ~/.local/share/nvim/backup
    rm -rf ~/.local/share/nvim/swap
    rm -rf ~/.local/share/nvim/undo
    notify-send "🗑️ Neovim Cache" 'Recuerda reaplicar fondos y ajustar QT5/QT6, lxa y nwglook  🎨'
    ;;
  7)
    echo "⚠️ Reinstalando todos los plugins de Neovim..."
    echo "Esto fuerza la descarga de repositorios: útil para depurar updates, cambiar nombres de repo (como Supermaven) o forzar un downgrade."
    # Elimina el directorio de plugins y caché de Lazy/Packer
    rm -rf ~/.local/share/nvim/{lazy,packer,site,lspconfig,log} # limpieza selectiva
    # rm -rf ~/.local/share/nvim                                  # limpieza total
    echo "Directorio de plugins borrado. Los plugins se reinstalarán al abrir Neovim."
    notify-send "🔄 Plugins Neovim Eliminados" \
      'Abre NVIM y ejecuta :Lazy sync o :PackerSync para reinstalar todos los plugins.'
    # nvim & # <--- Se ejecuta en background, el script continúa inmediatamente
    ;;
  8)
    echo "Saliendo..."
    exit 0
    ;;
  *)
    echo "Opción no válida."
    ;;
  esac

  echo "✅ Operación completada."
  read -rp "Presiona Enter para volver al menú..."
done
