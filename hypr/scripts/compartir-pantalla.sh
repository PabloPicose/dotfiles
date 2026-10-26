#!/usr/bin/env bash
# Selector para compartir pantalla (xdph.conf → custom_picker_binary), en fuzzel.
# El de xdph pone "Screen 0/1/2" en orden interno, que no casa con la posición ni con el escritorio de waybar.
# Aquí: pantallas de izquierda a derecha con su escritorio; "Ventana o región…" abre el selector de xdph.
# xdph lee la salida: "[SELECTION]/screen:DP-1" (vacío = cancelar).

choice=$( {
    hyprctl monitors -j |
        jq -r 'sort_by(.x) as $m | ($m | length) as $n | $m | to_entries[]
               | (if $n == 3 then ["Izquierda", "Centro", "Derecha"][.key] else "Pantalla \(.key + 1)" end) as $pos
               | "screen:\(.value.name)\t\($pos) — escritorio \(.value.activeWorkspace.name)  (\(.value.name), \(.value.width)x\(.value.height))"'
    printf 'picker\tVentana o región…\n'
} | fuzzel --dmenu --with-nth 2 --accept-nth 1 --prompt "󰍹 " --placeholder "Compartir..." --width 60 --lines 4)

case "$choice" in
    picker)   exec hyprland-share-picker ;;
    screen:*) echo "[SELECTION]/$choice" ;;
esac
