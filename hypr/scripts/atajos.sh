#!/usr/bin/env bash
# Manual de atajos en kitty flotante con nvim (solo lectura, markdown renderizado). q para salir.
# Si ya está abierto, lo enfoca en vez de abrir otro.
manual=~/ai/hyperland/manual.md
if hyprctl clients -j | jq -e 'any(.[]; .class == "atajos")' >/dev/null; then
    hyprctl dispatch 'hl.dsp.focus({ window = "class:^(atajos)$" })'
else
    kitty --class atajos nvim -R -c 'setlocal nomodifiable' -c 'nnoremap <buffer> q <cmd>qa<CR>' "$manual"
fi
