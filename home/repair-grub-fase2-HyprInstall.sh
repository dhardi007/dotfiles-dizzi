#!/bin/bash
# fase2-HyprInstall-full.sh
# Script OPTIMIZADO SIN COMPILACIONES LARGAS
# Ejecutar como usuario normal después de archinstall
# Version ULTRA-FAST: Solo paquetes -bin precompilado

# +++- anotaciones
# Script perfeccionado con todas las mejoras solicitadas
# - Caelestia/Quickshell/Eww: Instalación interactiva (s/n)
# - Stremio: Instalación interactiva opcional
# - Editor: Selección interactiva VSCode/Cursor/Antigravity
# - Ollama + opencommit (oco) con modelo qwen2.5:0.5b
# - Kafka cursor: Búsqueda en múltiples rutas + config Hyprland
# - 35 pasos totales con todas las features esenciales

set -e

# ═══════════════════════════════════════════════════════════
# COLORES Y FUNCIONES
# ═══════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

function print_header() {
  echo
  echo -e "${BOLD}${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}║ $1${NC}"
  echo -e "${BOLD}${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
  echo
}

function print_step() {
  echo
  echo -e "${BOLD}${BLUE}▶ PASO $1${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

function print_package() { echo -e "  ${MAGENTA}📦${NC} $1"; }
function print_status() { echo -e "${BLUE}[⚡]${NC} $1"; }
function print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
function print_error() { echo -e "${RED}[✗]${NC} $1"; }
function print_warning() { echo -e "${YELLOW}[⚠]${NC} $1"; }
function print_installing() { echo -e "${CYAN}[↓]${NC} Instalando: ${BOLD}$1${NC}"; }

# ═══════════════════════════════════════════════════════════
# VERIFICACIONES
# ═══════════════════════════════════════════════════════════
if [[ $EUID -eq 0 ]]; then
  print_error "NO ejecutar como root. Ejecuta como usuario normal."
  exit 1
fi

if ! command -v sudo &>/dev/null; then
  print_error "Sudo no está instalado. Configúralo primero."
  exit 1
fi

if ! ping -c 1 archlinux.org &>/dev/null; then
  print_error "Sin internet. Conecta con: sudo systemctl start NetworkManager && nmtui"
  exit 1
fi

# ═══════════════════════════════════════════════════════════
# INTRO
# ═══════════════════════════════════════════════════════════
clear
cat <<"EOF"

██╗░░██╗██╗░░░██╗██████╗░██████╗░██╗░░░░░░█████╗░███╗░░██╗██████╗░
██║░░██║╚██╗░██╔╝██╔══██╗██╔══██╗██║░░░░░██╔══██╗████╗░██║██╔══██╗
███████║░╚████╔╝░██████╔╝██████╔╝██║░░░░░███████║██╔██╗██║██║░░██║
██╔══██║░░╚██╔╝░░██╔═══╝░██╔══██╗██║░░░░░██╔══██║██║╚████║██║░░██║
██║░░██║░░░██║░░░██║░░░░░██║░░██║███████╗██║░░██║██║░╚███║██████╔╝
╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░

╔══════════════════════════════════════════════════════════════════════╗
║        🚀 INSTALACIÓN ULTRA-FAST HYPRLAND 🚀                         ║
║   COPIA DE GRUB MINE-CRAFT extraida de: fase2-HyprInstall-full.sh    ║
╚══════════════════════════════════════════════════════════════════════╝

EOF

echo -e "${GREEN}${BOLD}Esta instalación incluye:${NC}"
echo "  • Configuraciones de Grub Mine-Craft"
echo "  • Algunos scripts de Omarchy [webpack, arch install]"
echo "  • Servicios: Gemini, Espanso, Kanata, GDrive mounts, ydotool"
echo "  • Dotfiles dizzi1222"
echo
echo -e "${RED}${BOLD}OPTIMIZACIONES:${NC}"
echo "  • Solo paquetes -bin (precompilados)"
echo
echo -e "${YELLOW}${BOLD}Duración estimada: 25-35 minutos${NC}"
echo
read -p "¿Continuar? [S/n]: " confirm
[[ "$confirm" =~ ^[Nn]$ ]] && exit 0

# ═══════════════════════════════════════════════════════════
# SUDO KEEPALIVE
# ═══════════════════════════════════════════════════════════
sudo -v
(while true; do
  sudo -n true
  sleep 50
done 2>/dev/null) &
SUDO_PID=$!
trap "kill $SUDO_PID 2>/dev/null" EXIT

# ═══════════════════════════════════════════════════════════
# PASO 25.5: GRUB (CORREGIDO - Faltaba fi)
# ═══════════════════════════════════════════════════════════
print_step "25.5/35: GRUB + Iconos"

echo
read -p "¿Instalar temas Minecraft para GRUB? [S/n]: " install_minecraft_grub

if [[ ! "$install_minecraft_grub" =~ ^[Nn]$ ]]; then
  print_header "Instalando Temas Minecraft"

  sudo mkdir -p /boot/grub/themes

  # World Selection
  if [[ ! -d /boot/grub/themes/minegrub-world-selection ]]; then
    git clone --depth 1 https://github.com/Lxtharia/minegrub-world-selection.git /tmp/minegrub-ws
    sudo cp -r /tmp/minegrub-ws/minegrub-world-selection /boot/grub/themes/
    rm -rf /tmp/minegrub-ws
    print_success "World Selection instalado"
  fi

  # Classic
  if [[ ! -d /boot/grub/themes/minegrub ]]; then
    git clone --depth 1 https://github.com/Lxtharia/minegrub-theme.git /tmp/minegrub-classic
    sudo cp -r /tmp/minegrub-classic/minegrub /boot/grub/themes/
    rm -rf /tmp/minegrub-classic
    print_success "Classic instalado"
  fi

  echo
  read -p "¿Reconfigurar GRUB? [S/n]: " reconfig_grub

  if [[ ! "$reconfig_grub" =~ ^[Nn]$ ]]; then
    if [[ -L /etc/default/grub ]]; then
      sudo grub-mkconfig -o /boot/grub/grub.cfg
      print_success "GRUB reconfigurado"
    else
      print_warning "Symlink GRUB no existe"
    fi
  fi
fi # 🔴 ESTE FI FALTABA

print_status "Actualizando cachés..."
update-desktop-database ~/.local/share/applications 2>/dev/null || true
gtk-update-icon-cache -f ~/.local/share/icons 2>/dev/null || true

# ═══════════════════════════════════════════════════════════
# PASO 16: DOTFILES
# ═══════════════════════════════════════════════════════════
print_step "16/35: Dotfiles dizzi1222"
if [[ ! -d ~/dotfiles-dizzi ]]; then
  print_installing "Clonando dotfiles desde GitHub"
  git clone https://github.com/dizzi1222/dotfiles-dizzi.git ~/dotfiles-dizzi || {
    print_warning "Error clonando dotfiles"
  }
fi

if [[ -d ~/dotfiles-dizzi ]]; then
  cd ~/dotfiles-dizzi

  print_status "Inicializando submódulos git..."
  git submodule update --init --recursive 2>/dev/null || print_warning "No hay submódulos o falló su actualización"

  print_status "Aplicando dotfiles con stow..."

  for pkg in kdenlive-compressor-editor sattyScreenshots Antigravity nwg-gtk-3.0 nwg-gtk-4.0 qt5ct qt6ct thunar ibus Raycast-vicinae fuzzel-glyphs-rofimoji autostart copyq dunst easyeffects swaync espanso eww fastfetch font ghostty home hypr kew kitty local nvim rofi systemd themes wal wallpapers waybar wireplumber wofi yazi zsh input-remapper quickshell caelestia icons firefox vscode cursor manual-ln htop neofetch tmux polybar bottom starship nixconf qtile; do
    if [[ -d $pkg ]]; then
      print_package "Stow: $pkg"
      stow $pkg 2>/dev/null || print_warning "Stow falló para $pkg"
    fi
  done

  cd ~
  print_success "Dotfiles aplicados"
fi

# ═══════════════════════════════════════════════════════════
# PASO 17: SYMLINKS A /etc
# ═══════════════════════════════════════════════════════════
print_step "17/35: Symlinks a /etc (udev/polkit/bluetooth/pam.d) para Gnome Keyring y mas"

if [[ -d ~/dotfiles-dizzi/etc ]]; then
  print_status "Creando symlinks desde dotfiles a /etc"

  # UDEV rules para controles
  if [[ -f ~/dotfiles-dizzi/etc/udev/rules.d/99-dualsense-controllers.rules ]]; then
    print_package "Symlink: DualSense (PS5)"
    sudo ln -sf ~/dotfiles-dizzi/etc/udev/rules.d/99-dualsense-controllers.rules /etc/udev/rules.d/
  fi

  if [[ -f ~/dotfiles-dizzi/etc/udev/rules.d/99-ds4-controllers.rules ]]; then
    print_package "Symlink: DualShock 4 (PS4)"
    sudo ln -sf ~/dotfiles-dizzi/etc/udev/rules.d/99-ds4-controllers.rules /etc/udev/rules.d/
  fi

  if [[ -f ~/dotfiles-dizzi/etc/udev/rules.d/99-ds3-controllers.rules ]]; then
    print_package "Symlink: DualShock 3 (PS3)"
    sudo ln -sf ~/dotfiles-dizzi/etc/udev/rules.d/99-ds3-controllers.rules /etc/udev/rules.d/
  fi

  # Bluetooth input config
  if [[ -f ~/dotfiles-dizzi/etc/bluetooth/input.conf ]]; then
    print_package "Symlink: Bluetooth input.conf (deshabilitar PIN)"
    sudo ln -sf ~/dotfiles-dizzi/etc/bluetooth/input.conf /etc/bluetooth/
  fi

  # Input Remapper UDEV + Polkit
  if [[ -f ~/dotfiles-dizzi/etc/udev/rules.d/99-input-remapper.rules ]]; then
    print_package "Symlink: Input Remapper UDEV"
    sudo ln -sf ~/dotfiles-dizzi/etc/udev/rules.d/99-input-remapper.rules /etc/udev/rules.d/
  fi

  if [[ -f ~/dotfiles-dizzi/etc/polkit-1/rules.d/90-input-remapper-user.rules ]]; then
    print_package "Symlink: Input Remapper Polkit"
    sudo mkdir -p /etc/polkit-1/rules.d
    sudo ln -sf ~/dotfiles-dizzi/etc/polkit-1/rules.d/90-input-remapper-user.rules /etc/polkit-1/rules.d/
  fi

  # Para permisos de luces
  if [[ -f ~/dotfiles-dizzi/etc/udev/rules.d/90-kbd-backlight.rules ]]; then
    print_package "Symlink: Luces de teclado"
    sudo ln -sf ~/dotfiles-dizzi/etc/udev/rules.d/90-kbd-backlight.rules /etc/udev/rules.d/90-kbd-backlight.rules
  fi

  # GRUB config
  if [[ -f ~/dotfiles-dizzi/etc/default/grub ]]; then
    print_package "Symlink: GRUB config"
    sudo ln -sf ~/dotfiles-dizzi/etc/default/grub /etc/default/
  fi

  # Para solucionar gnome Keyring en SDDM y GNOME
  if [[ -f ~/dotfiles-dizzi/etc/pam.d/sddm ]]; then
    print_package "Symlink: SDDM pam.d para Gnome Keyring"
    sudo pacman -S gnome-keyring --needed --noconfirm
    sudo ln -sf ~/dotfiles-dizzi/etc/pam.d/sddm /etc/pam.d/sddm
  fi

  # Recargar servicios
  print_status "Recargando udev y polkit..."
  sudo udevadm control --reload-rules
  sudo udevadm trigger
  sudo systemctl restart polkit 2>/dev/null || true

  print_success "Symlinks a /etc creados"
else
  print_warning "No se encontró ~/dotfiles-dizzi/etc, omitiendo symlinks"
fi

# ═══════════════════════════════════════════════════════════
# PASO 19: SERVICIOS DEL SISTEMA
# ═══════════════════════════════════════════════════════════
print_step "19/35: Servicios del Sistema"
print_installing "UFW Firewall + Power Profiles"
sudo pacman -S --needed --noconfirm ufw
sudo ufw enable
sudo systemctl enable ufw
sudo systemctl enable power-profiles-daemon

print_status "Agregando usuario a grupos..."
for group in video audio storage input docker wheel uinput; do
  sudo usermod -aG $group $USER 2>/dev/null || true
  print_package "Grupo: $group"
done

print_success "Servicios del sistema configurados"

# ═══════════════════════════════════════════════════════════
# PASO 20: SERVICIOS SYSTEMD USER
# ═══════════════════════════════════════════════════════════
print_step "20/35: Servicios Systemd (User)"

echo
read -p "¿Habilitar servicios systemd de usuario? [S/n]: " enable_services

if [[ ! "$enable_services" =~ ^[Nn]$ ]]; then
  print_status "Habilitando servicios systemd de usuario..."

  # Gemini CLI
  if [[ -f ~/.config/systemd/user/gemini.service ]]; then
    print_package "Habilitando: gemini.service"
    systemctl --user enable gemini.service 2>/dev/null || print_warning "gemini.service no encontrado"
    systemctl --user start gemini.service 2>/dev/null || true
  fi

  # Espanso
  if [[ -f ~/.config/systemd/user/espanso.service ]]; then
    killall espanso
    print_package "Habilitando: espanso.service"
    systemctl --user enable espanso.service 2>/dev/null || print_warning "espanso.service no encontrado"
    systemctl --user start espanso.service 2>/dev/null || true
    espanso service register
    # Start espanso:
    espanso start
  fi

  # Kanata
  if [[ -f ~/.config/systemd/user/kanata.service ]]; then
    print_package "Habilitando: kanata.service"
    systemctl --user enable kanata.service 2>/dev/null || print_warning "kanata.service no encontrado"
    systemctl --user start kanata.service 2>/dev/null || true
  fi

  # GDrive mount
  if [[ -f ~/.config/systemd/user/montar_gdrive.service ]]; then
    print_package "Habilitando: montar_gdrive.service"
    systemctl --user enable montar_gdrive.service 2>/dev/null || print_warning "montar_gdrive.service no encontrado"
    systemctl --user start montar_gdrive.service 2>/dev/null || true
  fi

  # GDrive música
  if [[ -f ~/.config/systemd/user/montar_gdmusica.service ]]; then
    print_package "Habilitando: montar_gdmusica.service"
    systemctl --user enable montar_gdmusica.service 2>/dev/null || print_warning "montar_gdmusica.service no encontrado"
    systemctl --user start montar_gdmusica.service 2>/dev/null || true
  fi

  # MPRIS cover update
  if [[ -f ~/.config/systemd/user/update-cover.loop.service ]]; then
    print_package "Habilitando: update-cover.loop.service"
    systemctl --user enable update-cover.loop.service 2>/dev/null || print_warning "update-cover.loop.service no encontrado"
    systemctl --user start update-cover.loop.service 2>/dev/null || true
  fi

  # ydotool
  if [[ -f ~/.config/systemd/user/ydotool.service ]]; then
    print_package "Habilitando: ydotool.service"
    systemctl --user enable ydotool.service 2>/dev/null || print_warning "ydotool.service no encontrado"
    systemctl --user start ydotool.service 2>/dev/null || true
  fi

  print_success "Servicios de usuario habilitados"
else
  print_warning "Servicios de usuario omitidos"
fi

# Input-remapper (system service) - CORREGIDO: nombre correcto del servicio
print_status "Habilitando input-remapper (system service)..."
if systemctl list-unit-files | grep -q "input-remapper"; then
  sudo systemctl enable --now input-remapper 2>/dev/null || sudo systemctl enable --now input-remapper.service 2>/dev/null
  print_success "input-remapper habilitado"
else
  print_warning "input-remapper no encontrado (instalar con: yay -S input-remapper-git)"
fi

# ═══════════════════════════════════════════════════════════
# PASO 25: GRUVBOX (CORREGIDO - Cierre de bloques)
# ═══════════════════════════════════════════════════════════
print_step "25/35: Gruvbox Ecosystem"

echo
read -p "¿Instalar Gruvbox Icon Pack? [S/n]: " install_gruvbox_icons
read -p "¿Instalar Gruvbox GTK Theme? [S/n]: " install_gruvbox_gtk

# Icons
if [[ ! "$install_gruvbox_icons" =~ ^[Nn]$ ]]; then
  print_header "Instalando Gruvbox Icons"

  yay -S --needed --noconfirm --answerdiff=None --answerclean=None --removemake \
    gruvbox-plus-icon-theme 2>/dev/null || print_warning "Gruvbox icons falló"

  gsettings set org.gnome.desktop.interface icon-theme 'gruvbox-plus-icon-pack' 2>/dev/null || true

  if [[ -f ~/.config/hypr/hyprland.conf ]]; then
    if ! grep -q "GTK_ICON_THEME.*gruvbox" ~/.config/hypr/hyprland.conf; then
      echo "env = GTK_ICON_THEME,gruvbox-plus-icon-pack" >>~/.config/hypr/hyprland.conf
    fi
  fi

  print_success "Gruvbox icons instalado"
fi

# GTK Theme
if [[ ! "$install_gruvbox_gtk" =~ ^[Nn]$ ]]; then
  print_header "Instalando Gruvbox GTK"

  yay -S --needed --noconfirm --answerdiff=None --answerclean=None --removemake \
    gruvbox-gtk-theme-git 2>/dev/null || print_warning "Gruvbox GTK falló"

  gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark' 2>/dev/null || true
  print_success "Gruvbox GTK instalado"
fi

# ═══════════════════════════════════════════════════════════
# PASO 33: CONFIGURACIÓN AUTOMÁTICA DE TEMAS QT/GTK
# ═══════════════════════════════════════════════════════════
print_step "33/35: Configuración Automática de Temas"

echo
read -p "¿Configurar temas Qt/GTK automáticamente? [S/n]: " config_themes

if [[ ! "$config_themes" =~ ^[Nn]$ ]]; then
  print_header "Configurando Temas del Sistema"

  # Instalar gestores de temas si no están
  sudo pacman -S --needed --noconfirm \
    qt5ct qt6ct nwg-look lxappearance kvantum

  # Configurar Qt para usar temas oscuros
  print_installing "Configurando Qt5/Qt6"

  # Qt5
  mkdir -p ~/.config/qt5ct
  cat >~/.config/qt5ct/qt5ct.conf <<'EOL'
[Appearance]
style=kvantum-dark
color_scheme_path=~/.config/qt5ct/colors/darker.conf

[Fonts]
fixed=@Variant(\0\0\0@\0\0\0\x12\0J\0e\0t\0B\0r\0a\0i\0n\0s@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
general=@Variant(\0\0\0@\0\0\0\x12\0J\0e\0t\0B\0r\0a\0i\0n\0s@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
EOL

  # Qt6
  mkdir -p ~/.config/qt6ct
  cat >~/.config/qt6ct/qt6ct.conf <<'EOL'
[Appearance]
style=kvantum-dark
color_scheme_path=~/.config/qt6ct/colors/darker.conf

[Fonts]
fixed=@Variant(\0\0\0@\0\0\0\x12\0J\0e\0t\0B\0r\0a\0i\0n\0s@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
general=@Variant(\0\0\0@\0\0\0\x12\0J\0e\0t\0B\0r\0a\0i\0n\0s@$\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
EOL

  # Variables de entorno para Qt
  if [[ -f ~/.config/hypr/hyprland.conf ]]; then
    if ! grep -q "QT_QPA_PLATFORMTHEME" ~/.config/hypr/hyprland.conf; then
      echo "env = QT_QPA_PLATFORMTHEME,qt6ct" >>~/.config/hypr/hyprland.conf
    fi
  fi

  # Configurar GTK para tema oscuro
  print_installing "Configurando GTK"

  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

  # Si existe tema Colloid en dotfiles, aplicarlo
  if [[ -d ~/.themes/Colloid-Dark ]]; then
    gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Dark' 2>/dev/null || true
  fi

  print_success "Temas configurados"
else
  print_warning "Configuración de temas omitida"
fi

# ═══════════════════════════════════════════════════════════
# PASO 34: DESACTIVAR GESTOR DE LOGIN ACTUAL
# ═══════════════════════════════════════════════════════════
print_step "33.5/35: Desactivar Display Manager Actual"

# Detectar gestor actual
CURRENT_DM=""
if systemctl is-enabled gdm &>/dev/null; then
  CURRENT_DM="gdm"
elif systemctl is-enabled sddm &>/dev/null; then
  CURRENT_DM="sddm"
elif systemctl is-enabled lightdm &>/dev/null; then
  CURRENT_DM="lightdm"
fi

if [[ -n "$CURRENT_DM" ]]; then
  print_warning "Gestor actual detectado: $CURRENT_DM"

  read -p "¿Desactivar $CURRENT_DM antes de instalar nuevo gestor? [S/n]: " disable_dm

  if [[ ! "$disable_dm" =~ ^[Nn]$ ]]; then
    print_status "Desactivando $CURRENT_DM..."
    sudo systemctl stop $CURRENT_DM 2>/dev/null || true
    sudo systemctl disable $CURRENT_DM
    print_success "$CURRENT_DM desactivado"
  fi
else
  print_status "No se detectó ningún gestor de login activo"
fi

# ═══════════════════════════════════════════════════════════
# PASO 35: DISPLAY MANAGER (GDM O SDDM) - MEJORADO
# ═══════════════════════════════════════════════════════════
print_step "34/35: Display Manager (GDM o SDDM)"

echo
echo -e "${BOLD}${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${YELLOW}║          🖥️  SELECCIONAR DISPLAY MANAGER 🖥️              ║${NC}"
echo -e "${BOLD}${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}"
echo
echo -e "${CYAN}Opciones disponibles:${NC}"
echo
echo -e "${BOLD}${GREEN}1. GDM (GNOME Display Manager)${NC}"
echo -e "  ${MAGENTA}•${NC} Interfaz limpia y moderna"
echo -e "  ${MAGENTA}•${NC} Soporte Wayland nativo"
echo -e "  ${MAGENTA}•${NC} Más ligero (~100MB RAM)"
echo
echo -e "${BOLD}${GREEN}2. SDDM + Astronaut Theme (MEJORADO)${NC}"
echo -e "  ${MAGENTA}•${NC} ${BOLD}Setup.sh interactivo funcional${NC}"
echo -e "  ${MAGENTA}•${NC} 10 temas visuales pre-hechos"
echo -e "  ${MAGENTA}•${NC} Wallpapers animados"
echo -e "  ${MAGENTA}•${NC} Teclado virtual integrado"
echo -e "  ${MAGENTA}•${NC} Instalación robusta y confiable"
echo
echo -e "${BOLD}${GREEN}3. Ninguno${NC} (mantener actual)"
echo
read -p "Seleccionar Display Manager [1=GDM, 2=SDDM, 3=Ninguno]: " dm_choice

if [[ "$dm_choice" == "2" ]]; then
  print_header "🚀 Instalando SDDM + Astronaut Theme (Versión Mejorada)"

  # Paso 1: Instalar SDDM y dependencias
  print_installing "SDDM + Dependencias Qt6"
  sudo pacman -S --needed --noconfirm \
    sddm qt6-svg qt6-virtualkeyboard qt6-multimedia qt6-multimedia-ffmpeg

  print_success "SDDM instalado"

  # Paso 2: Limpiar instalación anterior si existe
  print_status "Limpiando instalaciones previas del tema..."
  sudo rm -rf /usr/share/sddm/themes/sddm-astronaut-theme
  rm -rf /tmp/sddm-astronaut-theme

  # Paso 3: Clonar tema en /tmp
  print_installing "Clonando tema Astronaut"
  cd /tmp
  git clone --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git
  cd sddm-astronaut-theme

  print_success "Tema clonado"

  # Paso 4: Verificar que setup.sh existe
  if [[ ! -f "setup.sh" ]]; then
    print_error "Error: setup.sh no encontrado"
    print_warning "Instalando tema manualmente..."

    # Fallback: instalación manual
    sudo cp -r /tmp/sddm-astronaut-theme /usr/share/sddm/themes/

    if [[ -d /usr/share/sddm/themes/sddm-astronaut-theme/Fonts ]]; then
      sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/ 2>/dev/null || true
      fc-cache -fv >/dev/null
    fi
  else
    # Paso 5: Hacer setup.sh ejecutable
    chmod +x setup.sh

    # Paso 6: Ejecutar setup.sh INTERACTIVO
    print_status "Iniciando configuración interactiva del tema..."
    echo
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  ${BOLD}CONFIGURACIÓN INTERACTIVA DEL TEMA ASTRONAUT${NC}${CYAN}    ║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║  Podrás elegir:                                       ║${NC}"
    echo -e "${CYAN}║  • Uno de los 10 temas visuales disponibles          ║${NC}"
    echo -e "${CYAN}║  • Personalizar colores y apariencia                 ║${NC}"
    echo -e "${CYAN}║  • Configurar wallpaper                              ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${YELLOW}${BOLD}Temas disponibles:${NC}"
    echo -e "  ${GREEN}1.${NC} classic           ${GREEN}6.${NC} penguin"
    echo -e "  ${GREEN}2.${NC} astronaut         ${GREEN}7.${NC} jake_the_dog"
    echo -e "  ${GREEN}3.${NC} future            ${GREEN}8.${NC} rick_and_morty"
    echo -e "  ${GREEN}4.${NC} cyberpunk         ${GREEN}9.${NC} space_ship"
    echo -e "  ${GREEN}5.${NC} nixos            ${GREEN}10.${NC} custom"
    echo
    echo -e "${CYAN}${BOLD}Presiona Enter para continuar con la configuración...${NC}"
    read -p ""

    # Ejecutar setup.sh con sudo (necesario para copiar a /usr/share)
    sudo bash setup.sh

    print_success "Tema configurado mediante setup.sh"
  fi

  # Paso 7: Configurar SDDM para usar el tema
  print_status "Configurando SDDM..."

  sudo tee /etc/sddm.conf >/dev/null <<EOF
[Theme]
Current=sddm-astronaut-theme

[General]
InputMethod=qtvirtualkeyboard
EOF

  # Paso 8: Configurar teclado virtual en conf.d
  sudo mkdir -p /etc/sddm.conf.d
  sudo tee /etc/sddm.conf.d/virtualkbd.conf >/dev/null <<EOF
[General]
InputMethod=qtvirtualkeyboard
EOF

  print_success "Configuración de SDDM completada"

  # Paso 9: Copiar fuentes si existen
  if [[ -d /usr/share/sddm/themes/sddm-astronaut-theme/Fonts ]]; then
    print_status "Instalando fuentes del tema..."
    sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/ 2>/dev/null || true
    fc-cache -fv >/dev/null
    print_success "Fuentes instaladas"
  fi

  # Paso 10: Habilitar servicio SDDM
  print_status "Habilitando servicio SDDM..."
  sudo systemctl enable sddm
  print_success "SDDM habilitado"

  # Resumen final
  echo
  echo -e "${GREEN}${BOLD}✨ SDDM + Astronaut Theme instalado correctamente ✨${NC}"
  echo
  echo -e "${CYAN}Comandos útiles:${NC}"
  echo -e "  ${YELLOW}•${NC} Probar tema: ${YELLOW}sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme/${NC}"
  echo -e "  ${YELLOW}•${NC} Editar config: ${YELLOW}sudo nano /etc/sddm.conf${NC}"
  echo -e "  ${YELLOW}•${NC} Cambiar tema: ${YELLOW}cd /usr/share/sddm/themes/sddm-astronaut-theme && sudo bash setup.sh${NC}"
  echo

elif [[ "$dm_choice" == "1" ]]; then
  print_header "Instalando GDM"

  print_installing "GDM (GNOME Display Manager)"
  sudo pacman -S --needed --noconfirm gdm
  sudo systemctl enable gdm
  print_success "GDM habilitado"
else
  print_warning "Display Manager omitido (manteniendo actual)"
fi

# ═══════════════════════════════════════════════════════════
# PASO 35: LIMPIEZA FINAL
# ═══════════════════════════════════════════════════════════
print_step "35/35: Limpieza Final"
print_status "Eliminando paquetes huérfanos..."
sudo pacman -Rns $(pacman -Qtdq) --noconfirm 2>/dev/null || true
yay -Rns $(yay -Qdtq) --noconfirm 2>/dev/null || true

print_status "Limpiando caché..."
yay -Sc --noconfirm 2>/dev/null || true
sudo pacman -Sc --noconfirm 2>/dev/null || true
rm -rf ~/.cache/yay 2>/dev/null || true
rm -rf /tmp/sddm-astronaut-theme 2>/dev/null || true

print_success "Limpieza completada"

# ═══════════════════════════════════════════════════════════
# RESUMEN
# ═══════════════════════════════════════════════════════════
kill $SUDO_PID 2>/dev/null || true

clear
cat <<"EOF"

╔══════════════════════════════════════════════════════════════════════╗
║              🎉 INSTALACIÓN ULTRA-FAST COMPLETADA 🎉                 ║
╠══════════════════════════════════════════════════════════════════════╣
║  ✅ Servicios systemd habilitados                                    ║
║  ✅ Symlinks a /etc configurados                                     ║
║  ✅ Temas Qt/GTK configurados automáticamente                        ║
║  ✨ SDDM Astronaut Theme configurado interactivamente                ║
║  ✅  Grub Mine-Craft 󰍳 restaurado correctamente                     ║
╚══════════════════════════════════════════════════════════════════════╝

EOF

echo -e "${GREEN}${BOLD}Siguiente paso:${NC}"
echo -e "  ${CYAN}1.${NC} ${RED}CERRAR SESIÓN Y VOLVER A ENTRAR${NC} (crucial para grupos)"
echo -e "  ${CYAN}2.${NC} ${YELLOW}reboot${NC}"
echo -e "  ${CYAN}3.${NC} Seleccionar ${YELLOW}Hyprland${NC} en GDM/SDDM"
echo
echo -e "${YELLOW}${BOLD}SDDM Astronaut Theme:${NC}"
echo -e "  ${CYAN}•${NC} Tema activo: ${GREEN}$(grep -A1 '\[Theme\]' /etc/sddm.conf 2>/dev/null | grep Current | cut -d'=' -f2 || echo 'No configurado')${NC}"
echo -e "  ${CYAN}•${NC} Cambiar tema: ${YELLOW}cd /usr/share/sddm/themes/sddm-astronaut-theme && sudo bash setup.sh${NC}"
echo -e "  ${CYAN}•${NC} Probar: ${YELLOW}sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme/${NC}"
echo
echo -e "${YELLOW}${BOLD}Configuraciones post-instalación:${NC}"
echo -e "  ${CYAN}•${NC} Neovim: Abre ${YELLOW}nvim${NC} y ejecuta ${YELLOW}:MasonInstall prettier markdownlint-cli2${NC}"
echo -e "  ${CYAN}•${NC} Copilot: En nvim ejecuta ${YELLOW}:CopilotAuth${NC}"
echo -e "  ${CYAN}•${NC} Gemini CLI: ${YELLOW}gemini-cli setup${NC}"
echo -e "  ${CYAN}•${NC} Pywal: ${YELLOW}wal -i ~/wallpapers/tu-imagen.jpg${NC}"
echo -e "  ${CYAN}•${NC} Music Presence: ${YELLOW}source ~/.zshrc && musicpresence${NC}"
echo -e "  ${CYAN}•${NC} Rclone: ${YELLOW}~/montar_gdrive.sh${NC} (si configuraste)"
echo
echo -e "${YELLOW}${BOLD}Instalación manual (si omitiste):${NC}"
echo -e "  ${CYAN}•${NC} Bottles: ${YELLOW}yay -S bottles${NC} (1+ hora)"
echo -e "  ${CYAN}•${NC} Caelestia: ${YELLOW}yay -S caelestia-shell${NC} (30min)"
echo -e "  ${CYAN}•${NC} Quickshell: ${YELLOW}yay -S quickshell-git${NC} (15min)"
echo -e "  ${CYAN}•${NC} Stremio: ${YELLOW}yay -S stremio${NC} (10-15min)"
echo -e "  ${CYAN}•${NC} Ollama: ${YELLOW}sudo pacman -S ollama && ollama pull qwen2.5:0.5b${NC}"
echo
echo -e "${GREEN}${BOLD}Dotfiles:${NC}"
echo -e "  ${CYAN}•${NC} Aplicar todos: ${YELLOW}cd ~/dotfiles-dizzi && stow .${NC}"
echo -e "  ${CYAN}•${NC} Quitar todos: ${YELLOW}cd ~/dotfiles-dizzi && stow -D .${NC}"
echo -e "  ${CYAN}•${NC} Aplicar específico: ${YELLOW}cd ~/dotfiles-dizzi && stow hypr waybar rofi${NC}"
echo -e "  ${CYAN}•${NC}   PROBLEMAS CON LA CPU al 100%? # Ver CPU de otros procesos
  htop # --> Usa F6 para ordenar por CPU
  sudo intel_gpu_top # Ver GPU en tiempo real de Intel [latitude 7440]

  # O para ver CPU de otros procesos con grep (busca por nombre)
  # ...
  Btw ya parche y mejore los intervalos de waybar, eww, hypr, scripts etc.
  ps aux --sort=-%cpu | grep -E "eww | hypr | waybar | dunst | swaync | swww | caelestia" | head -20.${NC}"
echo
echo -e "${GREEN}¡Disfruta tu setup Hyprland perfeccionado con SDDM Astronaut! 🚀${NC}"
echo
