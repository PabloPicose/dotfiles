#!/usr/bin/env bash
# Menú de energía con fuzzel (SUPER+Escape). CTRL+j/k para moverse, Enter para elegir, Esc para cancelar.

choice=$(printf '%s\n' \
    "󰌾  Bloquear" \
    "󰍃  Cerrar sesión" \
    "󰒲  Suspender" \
    "󰜉  Reiniciar" \
    "󰐥  Apagar" |
    fuzzel --dmenu --prompt "❯ " --placeholder "Energía..." --lines 5 --width 25)

case "$choice" in
    *Bloquear)        pidof hyprlock || hyprlock ;;
    *"Cerrar sesión") hyprctl dispatch 'hl.dsp.exit()' ;;
    *Suspender)       systemctl suspend ;;
    *Reiniciar)       systemctl reboot ;;
    *Apagar)          systemctl poweroff ;;
esac
