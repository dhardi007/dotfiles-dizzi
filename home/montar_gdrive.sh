#!/bin/bash
fusermount -u ~/mi_gdrive 2>/dev/null
mkdir -p ~/mi_gdrive
rclone mount gdrive:/ ~/mi_gdrive --vfs-cache-mode full &
