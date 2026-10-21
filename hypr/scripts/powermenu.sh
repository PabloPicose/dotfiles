#!/usr/bin/env bash
# Menú de energía con fuzzel (SUPER+Escape). CTRL+j/k para moverse, Enter para elegir, Esc para cancelar.

choice=$(printf '%s\n' \
    "󰍃  Cerrar sesión" \
    "󰒲  Suspender" \
    "󰜉  Reiniciar" \
    "󰐥  Apagar" |
    fuzzel --dmenu --prompt "❯ " --placeholder "Energía..." --lines 4 --width 25)

# Arctis: al salir vuelve a 90 min (también vale en KDE); al suspender, 10 min (ver arctis-apagado.sh)
arctis=~/.config/hypr/scripts/arctis-apagado.sh
case "$choice" in
    *"Cerrar sesión") $arctis normal;  hyprctl dispatch 'hl.dsp.exit()' ;;
    *Suspender)       $arctis ausente; systemctl suspend ;;
    *Reiniciar)       $arctis normal;  systemctl reboot ;;
    *Apagar)          $arctis normal;  systemctl poweroff ;;
esac
