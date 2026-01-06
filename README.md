> ## 💤 🔮 In Love With Arch Hyprland 🗿 My Inspiration ✨🔥🚀

<div align="center">

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/29ba01b1-da5b-4b39-a612-360d69cb697a" />

## 🖤 Eww Waybar + Music Track 🎼

<img width="1366" height="114" alt="image" src="https://github.com/user-attachments/assets/eabcfb02-982f-4885-a75a-d30f84cebc01" />

## 💤 LazyVim 🦥


![Nvim WSL Desktop](https://github.com/user-attachments/assets/9144215e-6156-43c3-beba-4cca7f431337)

![Nvim Desktop](https://github.com/user-attachments/assets/60c80cc3-98d7-4af0-a5bd-8842a9c8c80d)


*Mi setup personalizado de Arch Linux + Hyprland*

</div>

---

## 📋 Tabla de Contenidos

- [🎨 Galería](#-galería)
- [🚀 Instalación Rápida](#-instalación-rápida)
  - [Preparación](#1-preparación)
  - [ArchInstall](#2-archinstall)
  - [Post-Instalación](#3-post-instalación)
- [🛠️ Configuración del Sistema](#️-configuración-del-sistema)
- [💻 Herramientas Incluidas](#-herramientas-incluidas)
- [🌍 Configuración Regional](#-configuración-regional)
- [📚 Recursos Adicionales](#-recursos-adicionales)

---

## 🎨 Galería

<details>
<summary><b>Ver Screenshots del Sistema</b></summary>

### Desktop Principal
![Desktop 1](https://github.com/user-attachments/assets/29ba01b1-da5b-4b39-a612-360d69cb697a)

### Barra de Estado
![Waybar](https://github.com/user-attachments/assets/eabcfb02-982f-4885-a75a-d30f84cebc01)

### 💤 LazyVim
![LazyVim Setup](https://github.com/user-attachments/assets/60c80cc3-98d7-4af0-a5bd-8842a9c8c80d)

*Mi configuración de [LazyVim](https://github.com/LazyVim/LazyVim) - [Documentación](https://lazyvim.github.io/installation)*

### Fastfetch
![Fastfetch Display](https://github.com/user-attachments/assets/4e5c4c97-a852-49a9-9718-acecfa6bfd00)

</details>

---

## 🚀 Instalación Rápida

### 📦 Requisitos Previos

- USB de **8GB mínimo** (recomendado 16GB para `pacman -Syu`)
- Conexión a internet (Ethernet o WiFi)
- Espacio en disco: **50GB mínimo** para instalación completa

---

### 1️⃣ Preparación

#### Descargar Arch Linux

```bash
# Descarga el ISO oficial
# 🔗 https://archlinux.org/download/
```

#### Crear USB Bootable

1. Descarga [Ventoy](https://www.ventoy.net/) o [Rufus](https://rufus.ie/)
2. Flashea el USB con la herramienta elegida
3. Copia el ISO de Arch Linux al USB

#### Bootear desde USB

1. Reinicia tu PC
2. Presiona `F2`, `ESC`, `F8`, `F9`, `F10` o `F12` para entrar al BIOS
3. Selecciona el USB como primer dispositivo de arranque

---

### 2️⃣ Conexión a Internet

#### Vía Ethernet
```bash
ping -c 5 archlinux.org
```

#### Vía WiFi (iwctl)

<details>
<summary>Ver tutorial WiFi completo</summary>

![Tutorial WiFi](https://github.com/user-attachments/assets/ea9630b6-84a9-4709-a7b7-b3dff93b6de8)

📺 **Video Tutorial:** [Configurar Red + ArchInstall (16 min)](https://www.youtube.com/watch?v=x2euFpcv7hw&t=426s)

```bash
iwctl
device list
# si aparece en powered: off ejecutas:
device wlan0 set-property Powered on
# Luego obten la lista de wlan0
station wlan0 get-networks
station wlan0 connect "NOMBRE_WIFI"
# Ingresa contraseña y espera 5 segundos
exit
```

</details>

#### Actualizar Sistema Pre-Instalación

```bash
pacman -Sy archinstall archlinux-keyring
pacman -Syu  # ~1.5GB
```

> ⚠️ **Importante:** Necesitas un USB de al menos **4GB** para `pacman -Syu`

---

### 3️⃣ Particionar Disco

<details>
<summary>Tutorial de particionado (Dual Boot)</summary>

![Dual Boot Guide](https://github.com/user-attachments/assets/721c7cad-31d9-4a93-af7a-fac83ea057e7)

📺 **Video Tutorial:** [Dual Boot + Particiones (8 min)](https://www.youtube.com/watch?v=tPYCd4w65-0&t=180s)

```bash
lsblk        # Ver discos disponibles
fdisk -l     # Detalles de particiones (sdb = discos externos, sda = particiones internas)

# Formatear disco (⚠️ CUIDADO: borra todo)
gdisk /dev/sda4  # Reemplaza 'sdb/sda' con tu disco
# Presiona: x → z → yes → yes

# Cambiar formato a Ext-4 (Ejemplo sda4)
sudo mkfs.ext4 -L arch /dev/sda4
```

</details>

---

### 4️⃣ <u>ArchInstall</u>

```
# (☢️⚠️SIEMPRE FALLA ES UN BODRIO♿)
archinstall
```

#### Configuración Recomendada de archinstall (Falla en ⚠️ Dualboot)

| Opción | Valor Recomendado |
|--------|-------------------|
| **Idioma** | Español/English |
| **Disco** | Tu disco (ej: `/dev/sdb`) |
| **Layout** | Wipe + BTRFS filesystem |
| **Encryption** | Opcional (contraseña) |
| **Bootloader** | GRUB |
| **Hostname** | `archlinux` |
| **Root password** | Tu contraseña segura |
| **Usuario** | Crear + agregar a sudoers → **diego** |
| **Profile** | Minimal |
| **Drivers gráficos** | Intel/AMD/Nvidia según GPU |
| **Audio** | PipeWire |
| **Network** | NetworkManager |
| **Timezone** | `America/Santo_Domingo` |

```bash
# Cuando pregunte "Chroot into system?": YES
# Instala herramientas básicas:
pacman -S firefox git vim base-devel

exit
reboot
```

### 5️⃣ 🗿ArchInstall manual con mi Script ✔️🗣️

> 📖 **Guía Detallada:** [Install Arch in 5 minutes](https://kskroyal.com/install-arch-linux-in-under-5-minutes-2023/)

---

### 🛠️ Configuración del Sistema

### 🔧 Paso 0: Montar Particiones

```bash
# Recuerda cambiar el formato a Ext-4 ya sea con archinstall (o manual):
sudo mkfs.ext4 -L arch /dev/sda4 
# -L = Label nombre-a-elección

# Opción 1: La segura
mount /dev/sda4 /mnt              # Partición Linux
mount --mkdir /dev/sda1 /mnt/boot/efi     # Partición EFI dualboot bootloader 

# Opcion 2: Si al intentar entrar con chroot falla puedes montar la particion de Linux de esta otra manera

# Primero desmonta la duplicada conflictiva 
umount -R /mnt
# Luego montala mediante el label configurado (osea arch)
mount /dev/disk/by-label/arch /mnt     # Particion Linux 
mount --mkdir /dev/sda1 /mnt/boot/efi     # Partición EFI dualboot bootloader 

```

### 🗣️ Paso 0.5: Entrar al chroot y montar grub
```
# Esto re importante 🗣️ Lee las particiones y genera el formato correcto [fstab]
genfstab -U /mnt >> /mnt/etc/fstab



# TIP: puedes ejecutar 
# pacstrap /mnt base-devel linux # ... [el resto de paquetes]
# Realidad: Es más comodo entrar al /mnt:

arch-chroot /mnt

pacman -S base base-devel linux linux-firmware archlinux-keyring efibootmgr dhcpcd networkmanager iwd nano vim zsh

systemctl enable NetworkManager
systemctl enable iwd
systemctl enable 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --removable
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg

efibootmgr  # Verificar entrada GRUB

# Recomiendo ejecutar el script [FASE 1] desde chroot en vez de reiniciar, para agilizar.
```
> ### 🐎🃏 Paso 1: fase2-HyprInstall-full.sh y HYPER-arch-INSTALL.sh [fase1] 👨‍💻 los mejores scripts para instalar ARCH 🐧🃏

```
# Clonar este mismo repositorio 
git clone https://github.com/dizzi1222/dotfiles-dizzi.git ~/dotfiles-dizzi

# FASE 1: El script post entrar al chroot, asumiendo que ya instalaste base-devel etc
cd ~/dotfiles-dizzi
home/scripts/HYPER-arch-INSTALL.sh

# Una vez configurado el chroot, puedes reiniciar y proceder a instalar todos tus paquetes en tu usuario.

exit
reboot


# login: diego
# Password: 1111   - Ejemplo de credenciales

# FASE 2: El script QUE instala todos tus paquetes de forma interactiva 💀🗿

cd ~/dotfiles-dizzi
home/scripts/fase2-HyprInstall-full.sh
```

Apartir de aquí si enfrentas mas problemas como con el usuario, wlan, el siguiente contenido te guiará, y complementa lo que en teoría ya hace mis 2 script.

-----------------------------

> 💡 **Tip:** Identifica tu partición correcta con `lsblk` antes de montar

---

### 🎨 Paso 1.5: Entorno Gráfico

```bash
sudo pacman -S --needed gdm hyprland os-prober vim nano nvim zsh
sudo systemctl enable gdm
sudo systemctl start gdm
```

---

### 👤 Paso 2: Permisos de Usuario

```bash
# Arreglar permisos
sudo chown -R diego:diego /home/diego  # Reemplaza 'diego' con tu usuario

# Crear usuario (si no existe)
sudo useradd -m -g users -G wheel,audio,video,storage,power -s /bin/zsh diego

# Ver permisos de usuario existente
groups
groups diego # usuario

# Borrar usuario
sudo userdel diego # si agregas -rf diego borra el /home

# Cambiar contraseña
sudo passwd diego
```

#### Configurar Sudo

```bash
sudo EDITOR=nano visudo
```

Agrega o descomenta estas líneas:

```bash
root ALL=(ALL) ALL
%wheel ALL=(ALL:ALL) ALL
```

---

### 🌐 Paso 3: Internet y Bluetooth

```bash
sudo pacman -S --needed networkmanager bluez bluez-utils blueman
sudo systemctl enable NetworkManager bluetooth
sudo systemctl start NetworkManager bluetooth
```

> 💡 Conecta al WiFi desde GDM (pantalla de inicio) o desde Waybar

---

### 📁 Paso 4: Dotfiles y Programas

#### Clonar Dotfiles

```bash
git clone https://github.com/dizzi1222/dotfiles-dizzi.git ~/dotfiles-dizzi
cd ~/dotfiles-dizzi
```

#### Aplicar Configuraciones con Stow

```bash
# Opción 1: Aplicar todos
stow *

# Opción 2: Aplicar selectivamente
stow alacritty autostart bottom copyq cursor dunst easyeffects espanso \
     eww fastfetch ghostty home htop hypr kanata kew kitty local \
     manual-ln neofetch nixconf nvim picom polybar qtile rofi starship \
     systemd themes tmux wal wallpapers waybar wireplumber wofi xprofile \
     yazi zsh input-remapper quickshell caelestia icons firefox vscode
```

#### Configurar GRUB

```bash
sudo ln -sf ~/dotfiles-dizzi/etc/default/grub /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

#### Aplicar Reglas del Sistema

```bash
sudo ln -sf ~/dotfiles-dizzi/etc/bluetooth/input.conf /etc/bluetooth/
sudo ln -sf ~/dotfiles-dizzi/etc/udev/rules.d/99-input-remapper.rules /etc/udev/rules.d/
sudo ln -sf ~/dotfiles-dizzi/etc/polkit-1/rules.d/90-input-remapper-user.rules /etc/polkit-1/rules.d/

sudo udevadm control --reload-rules
sudo udevadm trigger
```

#### Actualizar Cachés

```bash
update-desktop-database ~/.local/share/applications
gtk-update-icon-cache -f ~/.local/share/icons
```

---

### ⌛ Paso 5: Zona Horaria

```bash
sudo timedatectl set-ntp true
sudo timedatectl set-timezone 'America/Santo_Domingo'
timedatectl status
```

---

### 🎨 Paso 6: Tablet Huion (Opcional)

```bash
yay -S huiontablet
```

---

### 🔠 Paso 7: Fuentes del Sistema

#### Fuentes Esenciales (~700MB)

```bash
sudo pacman -S --needed \
  ttf-nerd-fonts-symbols \
  ttf-nerd-fonts-symbols-mono \
  noto-fonts \
  noto-fonts-emoji \
  ttf-dejavu \
  ttf-jetbrains-mono-nerd \
  ttf-firacode-nerd \
  ttf-font-awesome
```

#### Fuentes CJK (Chino/Japonés/Coreano) - Opcional

```bash
sudo pacman -S --needed noto-fonts-cjk \
  adobe-source-han-sans-otc-fonts \
  adobe-source-han-serif-otc-fonts

# Refrescar caché
fc-cache -fv
```

---

### 🎨 Paso 8: Iconos Gruvbox

```bash
git clone https://github.com/SylEleuth/gruvbox-plus-icon-pack.git
cd gruvbox-plus-icon-pack

# Elige tu tema favorito
cp -rv Gruvbox-Plus-Dark ~/.local/share/icons
```

> 💡 Me gusta más Dracula 🧛🏻 theme, pero Gruvbox icons es god 🦥💤

---

## 🌍 Configuración Regional

### 🚨 Paso 9: Configurar Idioma (Español + Inglés)

#### Editar Locales

```bash
sudo sed -i 's/^#es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
```

**O manualmente:**

```bash
sudo nvim /etc/locale.gen

# Descomenta estas líneas:
es_ES.UTF-8 UTF-8
en_US.UTF-8 UTF-8
```

#### Regenerar Locales

```bash
sudo locale-gen
```

---

### 📌 Paso 10: Idioma por Defecto

```bash
echo "LANG=es_ES.UTF-8" | sudo tee /etc/locale.conf
echo "LC_COLLATE=C" | sudo tee -a /etc/locale.conf
```

**O manualmente:**

```bash
sudo nvim /etc/locale.conf

# Agrega:
LANG="es_ES.UTF-8"
LC_COLLATE=C
```

---

### 🔧 Configuraciones Avanzadas de Idioma

#### Forzar Inglés en Apps Específicas (ej: EWW)

```bash
export LC_ALL=C
export LANG=C
```

> 💡 Algunas apps como EWW requieren inglés para funciones específicas

#### Forzar Español en Apps que no Respetan Config (ej: Rofi)

```bash
LANG="es_ES.UTF-8" LC_COLLATE=C LC_ALL=es_ES.UTF-8 rofi
```

> ⚠️ **Nota:** `rofimoji` no es compatible con estas configuraciones (no es texto)

---

### ⌨️ Paso 11: Cambiar Teclado a Inglés (Opcional)

#### Temporal (solo sesión actual)

```bash
setxkbmap en
```

#### Permanente (Xorg)

```bash
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/00-keyboard.conf > /dev/null <<EOF
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "en"
    Option "XkbModel" "pc105"
EndSection
EOF
```

#### Permanente (Wayland / systemd)

```bash
sudo localectl set-x11-keymap en
```

---

### 🎮 Drivers Intel UHD 600 (Opcional)

```bash
sudo pacman -S vulkan-headers vulkan-icd-loader
```

> 🥔💻 Para mi patata... 🧨

---

## 💻 Herramientas Incluidas

### 🎨 Wallpapers

Gestión dinámica de wallpapers con [Pywal](https://github.com/dylanaraps/wal)

```bash
# Los wallpapers se encuentran en ~/dotfiles-dizzi/wallpapers
```

---

### 📊 Fastfetch

> Herramienta para mostrar información del sistema de forma atractiva

#### Instalación

```bash
cd ~/.local/share
git clone https://github.com/LierB/fastfetch
```

#### Uso

```bash
# Presets disponibles
fastfetch --config groups
fastfetch --config minimal

# Con opciones personalizadas
fastfetch --colors-block-range-start 9 --colors-block-width 3
```

**O copia tu preset favorito:**

```bash
cp preset.jsonc ~/.config/fastfetch/config.jsonc
fastfetch
```

---

## 📚 Recursos Adicionales

### 🎥 Videos Tutoriales

| Tutorial | Duración | Link |
|----------|----------|------|
| Configurar Red + ArchInstall | 16 min | [Ver](https://www.youtube.com/watch?v=x2euFpcv7hw&t=426s) |
| Dual Boot + Particiones | 8 min | [Ver](https://www.youtube.com/watch?v=tPYCd4w65-0&t=180s) |
| Debian vs Arch Comparison | Variable | [Ver](https://youtu.be/H7RQYREJO98) |

---

### 🔗 Enlaces Útiles

- 📖 [LazyVim Documentation](https://lazyvim.github.io/installation)
- 🎨 [Pywal Wallpapers](https://github.com/dylanaraps/wal)
- 📊 [Fastfetch Presets](https://github.com/LierB/fastfetch)
- 🗂️ [Gruvbox Icons](https://github.com/SylEleuth/gruvbox-plus-icon-pack)
- 📚 [Arch Linux Wiki](https://wiki.archlinux.org/)
- 🚀 [Hyprland Docs](https://wiki.hyprland.org/)

---

### 🔄 Otros Dotfiles

#### 💤 Debian vs Arch 🦥

<div align="center">

![Debian Rice](https://github.com/user-attachments/assets/39a8d975-cd82-4b68-9954-e1e1f784563f)
![Arch Rice](https://github.com/user-attachments/assets/ac37b985-489d-4801-a8ce-1fde7ef7446d)

**[Ver dotfiles para Arch, Debian y WSL](https://github.com/dizzi1222/dotfiles-wsl-dizzi/blob/main/README.md)**

![Comparison](https://github.com/user-attachments/assets/df6ecb56-d359-474d-8be1-bf68c48172ff)

</div>

---

## 🎯 Checklist de Instalación

- [ ] Descargar Arch Linux ISO
- [ ] Crear USB bootable con Ventoy/Rufus
- [ ] Bootear desde USB
- [ ] Conectar a internet (Ethernet/WiFi)
- [ ] Ejecutar `pacman -Syu`
- [ ] Particionar disco con `gdisk`
- [ ] Ejecutar `archinstall`
- [ ] Configurar GRUB (si es necesario)
- [ ] Instalar GDM + Hyprland
- [ ] Configurar permisos de usuario
- [ ] Clonar dotfiles
- [ ] Aplicar configuraciones con `stow`
- [ ] Instalar fuentes
- [ ] Configurar idioma y teclado
- [ ] Instalar iconos Gruvbox
- [ ] Configurar zona horaria
- [ ] Reiniciar y disfrutar 🚀

---

## 🤝 Contribuir

¿Encontraste algún error o quieres agregar algo? Abre un **Issue** o envía un **Pull Request**.

---

## 📝 Notas Finales

> 🦥💤 Configúralo tú, LaZY...

**Script completo finalizado. Reinicia para aplicar cambios:**

```bash
sudo reboot
```

---

<div align="center">

# 🌄🦥🗿 EL INICIO DE UN VIAJE POR EL COSMOS.. 🤓🚀🌌

**Hecho con 💜 y mucho ☕ por dizzi**

</div>
