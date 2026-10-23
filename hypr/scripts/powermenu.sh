#!/usr/bin/env bash
# Menú de energía con fuzzel (SUPER+Escape). CTRL+j/k para moverse, Enter para elegir, Esc para cancelar.

choice=$(printf '%s\n' \
    "󰍃  Cerrar sesión" \
    "󰒲  Suspender" \
    "󰜉  Reiniciar" \
    "󰐥  Apagar" |
    fuzzel --dmenu --prompt "❯ " --placeholder "Energía..." --lines 4 --width 25)

# Arctis: al cerrar sesión o reiniciar vuelve a 90 min (también vale en KDE); al suspender o apagar, 10 min
# para que el cascos se apague solo. Al entrar en KDE vuelve a 90 (arctis-normal-kde.service del metapaquete).
arctis=~/.config/hypr/scripts/arctis-apagado.sh
case "$choice" in
    *"Cerrar sesión") $arctis normal;  hyprctl dispatch 'hl.dsp.exit()' ;;
    *Suspender)       $arctis ausente; systemctl suspend ;;
    *Reiniciar)       $arctis normal;  systemctl reboot ;;
    *Apagar)          $arctis ausente; systemctl poweroff ;;
esac
