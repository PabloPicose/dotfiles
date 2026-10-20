#!/usr/bin/env bash
# Buscador de ventanas (SUPER+W): todas las ventanas abiertas en fuzzel; Enter salta a ella.
# Como el buscador de buffers de Telescope, pero para todo el escritorio.

choice=$(hyprctl clients -j |
    jq -r 'sort_by(.focusHistoryID) | .[]
           | select(.mapped and .title != "")
           | "\(.address)\t[\(.workspace.name | sub("special:"; "⋆"))] \(.class) — \(.title)"' |
    fuzzel --dmenu --with-nth 2 --accept-nth 1 --prompt "󰖯 " --placeholder "Ventana..." --width 70)

[ -n "$choice" ] && hyprctl dispatch "hl.dsp.focus({ window = \"address:$choice\" })"
