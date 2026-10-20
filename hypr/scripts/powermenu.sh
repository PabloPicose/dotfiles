#!/usr/bin/env bash
# Menú de energía con fuzzel (SUPER+Escape). CTRL+j/k para moverse, Enter para elegir, Esc para cancelar.

choice=$(printf '%s\n' \
    "󰍃  Cerrar sesión" \
    "󰒲  Suspender" \
    "󰜉  Reiniciar" \
    "󰐥  Apagar" |
    fuzzel --dmenu --prompt "❯ " --placeholder "Energía..." --lines 4 --width 25)

case "$choice" in
    *"Cerrar sesión") hyprctl dispatch 'hl.dsp.exit()' ;;
    *Suspender)       systemctl suspend ;;
    *Reiniciar)       systemctl reboot ;;
    *Apagar)          systemctl poweroff ;;
esac
