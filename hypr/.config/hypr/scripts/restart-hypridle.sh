#!/bin/bash
pkill -9 hypridle 2>/dev/null
systemctl --user start hypridle
