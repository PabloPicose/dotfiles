#!/usr/bin/env bash
# Busca en las tablas de manual.md con fuzzel (escribe "captura", "monitor"…). Enter copia la fila.
manual=~/ai/hyperland/manual.md
awk '
    function out(l) { gsub(/`/, "", l); gsub(/ *\| */, " │ ", l); sub(/^ │ /, "", l); sub(/ │ $/, "", l); print "[" sec "] " l }
    /^## /          { sec = substr($0, 4) }
    /^\|[ :|-]+\|$/ { prev = ""; next }          # separador: la fila anterior era la cabecera
    { if (prev != "") out(prev); prev = "" }
    /^\|/           { prev = $0 }
    END             { if (prev != "") out(prev) }
' "$manual" | fuzzel --dmenu --prompt "󰌌 " --placeholder "Buscar atajo..." --width 90 --lines 20 | wl-copy -n
