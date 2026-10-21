#!/usr/bin/env bash
# Mapa de ventanas en kitty flotante (SUPER+SHIFT+W). Interruptor: otra vez SUPER+SHIFT+W (o q) lo cierra.
pid=$(hyprctl clients -j | jq -r 'first(.[] | select(.class == "mapa-ventanas") | .pid) // empty')
if [ -n "$pid" ]; then
    kill "$pid"
else
    kitty --class mapa-ventanas -o confirm_os_window_close=0 python3 ~/.config/hypr/scripts/mapa-ventanas.py
fi
