#!/usr/bin/env bash
# Manual de atajos en kitty flotante con nvim (solo lectura, markdown renderizado).
# Interruptor: SUPER+A abre; otra vez SUPER+A (o q) cierra. Sin la confirmación de kitty al cerrar.
manual=~/ai/hyperland/manual.md
pid=$(hyprctl clients -j | jq -r 'first(.[] | select(.class == "atajos") | .pid) // empty')
if [ -n "$pid" ]; then
    kill "$pid"
else
    kitty --class atajos -o confirm_os_window_close=0 \
        nvim -R -c 'setlocal nomodifiable' -c 'nnoremap <buffer> q <cmd>qa<CR>' "$manual"
fi
