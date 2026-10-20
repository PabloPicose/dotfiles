#!/usr/bin/env bash
# Historial del portapapeles con fuzzel (SUPER+SHIFT+V).
# Elegir una entrada la vuelve a poner en el portapapeles → pegar con CTRL+V.
# Borrar todo el historial: cliphist wipe

cliphist list |
    fuzzel --dmenu --with-nth 2 --prompt "📋 " --placeholder "Portapapeles..." --width 60 |
    cliphist decode |
    wl-copy
