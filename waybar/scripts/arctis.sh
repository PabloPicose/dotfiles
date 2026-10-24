#!/usr/bin/env bash
# Batería del Arctis para waybar (custom/arctis). Lee el estado que ya tiene asm-daemon por D-Bus (no despierta el cascos).
# Cascos apagado o daemon parado → texto vacío y waybar oculta el módulo.
# La batería va en pasos de 25 % (el cascos da 0–4).
estado=$(busctl --user --json=short call name.giacomofurlan.ArctisManager.Next \
    /name/giacomofurlan/ArctisManager/Next/Status name.giacomofurlan.ArctisManager.Next.Status GetStatus 2>/dev/null) \
    || { echo '{"text": ""}'; exit 0; }
jq -c '.data[0] | fromjson
    | (.headset.headset_power_status.value // "") as $power
    | .headset.headset_battery_charge.value as $bat
    | .gamedac.charge_slot_battery_charge.value as $repuesto
    | if ($power | test("^(online|on)$")) | not then {text: ""}
      else {
        text: ("󰋋 " + (if $bat == null then "?" else "\($bat)%" end)),
        tooltip: ("Arctis: " + (if $bat == null then "batería desconocida" else "\($bat) %" end)
                  + (if $repuesto == null then "" else "\nBatería de repuesto (base): \($repuesto) %" end)),
        class: (if $bat == null then "unknown" elif $bat <= 25 then "low" else "ok" end)
      } end' <<<"$estado" 2>/dev/null || echo '{"text": ""}'
