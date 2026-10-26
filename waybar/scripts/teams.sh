#!/usr/bin/env bash
# Icono de Teams (app de Chrome) para waybar (custom/teams): las PWA de Chrome no ponen icono en la bandeja.
#   teams.sh        → JSON para waybar; sin ventana de Teams → texto vacío y waybar oculta el módulo
#   teams.sh focus  → ir a la ventana de Teams (clic)
# Si el título lleva contador de no leídos "(N)", se muestra al lado del icono.
clase="chrome-ompifgpmddkgmclendfeacglnodjjndh-Default"
ventana=$(hyprctl clients -j | jq -c --arg c "$clase" '[.[] | select(.class == $c)] | first // empty')

if [ "$1" = focus ]; then
    [ -n "$ventana" ] && hyprctl dispatch "hl.dsp.focus({ window = \"address:$(jq -r .address <<<"$ventana")\" })" >/dev/null
    exit 0
fi

[ -z "$ventana" ] && { echo '{"text": ""}'; exit 0; }
jq -c '.title as $t
    | ([$t | capture("\\((?<n>[0-9]+)\\)").n] | first) as $n
    | { text: ("󰊻" + (if $n then " \($n)" else "" end)),
        tooltip: $t,
        class: (if $n then "unread" else "open" end) }' <<<"$ventana"
