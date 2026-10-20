#!/usr/bin/env bash
# Arranca waybar y lo vuelve a lanzar si se cierra o se cae.
# Recargar la config de waybar: pkill -x waybar (este bucle lo reinicia en 1 s).
# NO usar pkill -SIGUSR2 waybar: con el módulo mpris deja callbacks colgando y waybar se cae (SIGSEGV).

while true; do
    waybar
    sleep 1
done
