#!/usr/bin/env bash
# Apagado automático del Arctis (Arctis Sound Manager, ajuste pm_shutdown) según si se usa el PC:
#   uso      → nunca (mientras se usa el PC; lo pone hypridle al volver y Hyprland al arrancar)
#   ausente  → 10 min (hypridle tras 10 min sin teclado/ratón, y al suspender)
#   normal   → 90 min (al salir de Hyprland: el ajuste se guarda en el cascos y también vale en KDE)
# Valores del cascos (arctis_pro_wireless.yaml): 0 nunca, 1 = 10 min, 2 = 20, 3 = 30, 6 = 60, 9 = 90.
case "$1" in
    uso)     valor=0 ;;
    ausente) valor=1 ;;
    normal)  valor=9 ;;
    *) echo "uso: $0 uso|ausente|normal" >&2; exit 1 ;;
esac
busctl --user call name.giacomofurlan.ArctisManager.Next /name/giacomofurlan/ArctisManager/Next/Settings \
    name.giacomofurlan.ArctisManager.Next.Settings SetSetting ss pm_shutdown "$valor" >/dev/null
