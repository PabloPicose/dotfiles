#!/usr/bin/env bash
# Lista de TUIs y comandos (~/.config/hypr/tuis.md) en kitty flotante con nvim. Editable para apuntar más.
# Interruptor: SUPER+SHIFT+T abre; otra vez SUPER+SHIFT+T (o q) cierra. Sin la confirmación de kitty al cerrar.
lista=~/.config/hypr/tuis.md
pid=$(hyprctl clients -j | jq -r 'first(.[] | select(.class == "tuis") | .pid) // empty')
if [ -n "$pid" ]; then
    kill "$pid"
else
    kitty --class tuis -o confirm_os_window_close=0 \
        nvim -c 'nnoremap <buffer> q <cmd>update<bar>qa<CR>' "$lista"
fi
