#!/bin/bash

# Configuración
COMFY_DIR="/home/diego/ComfyUI"
COMFY_PID_FILE="/tmp/comfyui.pid"
COMFY_PORT=8188

# Función para verificar si ya está ejecutándose
is_comfy_running() {
  # Verificar por PID file
  if [ -f "$COMFY_PID_FILE" ]; then
    local pid=$(cat "$COMFY_PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
      echo "✅ ComfyUI ya está ejecutándose (PID: $pid)"
      return 0
    else
      # PID file existe pero proceso no corre - limpiar
      rm -f "$COMFY_PID_FILE"
    fi
  fi

  # Verificar por puerto
  if netstat -tulpn 2>/dev/null | grep ":$COMFY_PORT" >/dev/null; then
    echo "🚫 ComfyUI ya está ejecutándose en puerto $COMFY_PORT"
    return 0
  fi

  # Verificar por proceso
  if pgrep -f "python main.py" >/dev/null; then
    echo "🚫 ComfyUI ya está ejecutándose (proceso encontrado)"
    return 0
  fi

  return 1
}

# Función para iniciar ComfyUI
start_comfy() {
  cd "$COMFY_DIR" || exit 1

  # Activar entorno virtual
  source venv/bin/activate

  # Iniciar ComfyUI en background y guardar PID
  python main.py --cpu &
  COMFY_PID=$!

  # Guardar PID en archivo
  echo $COMFY_PID >"$COMFY_PID_FILE"

  echo "🚀 Iniciando ComfyUI (PID: $COMFY_PID)..."

  # Esperar a que el servidor esté listo
  for i in {1..30}; do
    if curl -s http://127.0.0.1:8188 >/dev/null; then
      echo "✅ ComfyUI listo en http://127.0.0.1:8188"
      return 0
    fi
    sleep 1
  done

  echo "❌ Timeout: ComfyUI no se inició correctamente"
  return 1
}

# Función para abrir navegador
open_browser() {
  sleep 2
  xdg-open "http://127.0.0.1:8188" 2>/dev/null
}

# --- EJECUCIÓN PRINCIPAL ---

# Verificar si ya está ejecutándose
if is_comfy_running; then
  echo "📋 Abriendo navegador a instancia existente..."
  open_browser
  exit 0
fi

# Iniciar ComfyUI
echo "🎨 Iniciando ComfyUI..."
if start_comfy; then
  echo "🌐 Abriendo navegador..."
  open_browser &
else
  echo "❌ Error al iniciar ComfyUI"
  rm -f "$COMFY_PID_FILE"
  exit 1
fi

# Mantener script vivo mientras ComfyUI corre
wait
