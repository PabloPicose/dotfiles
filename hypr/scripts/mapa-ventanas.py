#!/usr/bin/env python3
"""Mapa de ventanas (SUPER+SHIFT+W): dibuja cada monitor con sus ventanas a escala.

Arriba, lo que se ve ahora en cada monitor (mosaico, flotantes encima, pantalla completa,
scratchpad si está abierto). Debajo, la lista numerada con todas las ventanas: las de otros
escritorios y las del scratchpad (SUPER+S) también. Escribir el número + Enter salta a ella.
Enter solo = refrescar · q = salir.
"""
import json
import shutil
import subprocess
import sys

CLASE_PROPIA = "mapa-ventanas"

# Catppuccin Macchiato (como kitty/fuzzel/waybar)
PALETA = ["#8aadf4", "#a6da95", "#f5a97f", "#c6a0f6", "#8bd5ca", "#eed49f",
          "#f5bde6", "#7dc4e4", "#ee99a0", "#b7bdf8", "#91d7e3", "#f0c6c6"]
TEXTO, TENUE, BORDE_MON, ROJO = "#cad3f5", "#6e738d", "#5b6078", "#ed8796"


def hypr(*args):
    return json.loads(subprocess.run(["hyprctl", *args, "-j"], capture_output=True, text=True).stdout)


def rgb(hexa, fondo=False):
    r, g, b = (int(hexa[i:i + 2], 16) for i in (1, 3, 5))
    return f"\033[{48 if fondo else 38};2;{r};{g};{b}m"


RESET, NEGRITA = "\033[0m", "\033[1m"


class Lienzo:
    def __init__(self, ancho, alto):
        self.ancho, self.alto = ancho, alto
        self.celdas = [[(" ", "")] * ancho for _ in range(alto)]

    def poner(self, x, y, car, estilo=""):
        if 0 <= x < self.ancho and 0 <= y < self.alto:
            self.celdas[y][x] = (car, estilo)

    def texto(self, x, y, s, estilo="", maximo=None):
        for i, car in enumerate(s[:maximo] if maximo else s):
            self.poner(x + i, y, car, estilo)

    def caja(self, x0, y0, x1, y1, estilo, rellenar=True, doble=False):
        h, v, esq = ("═", "║", "╔╗╚╝") if doble else ("─", "│", "╭╮╰╯")
        if rellenar:
            for y in range(y0 + 1, y1):
                for x in range(x0 + 1, x1):
                    self.poner(x, y, " ")
        for x in range(x0 + 1, x1):
            self.poner(x, y0, h, estilo)
            self.poner(x, y1, h, estilo)
        for y in range(y0 + 1, y1):
            self.poner(x0, y, v, estilo)
            self.poner(x1, y, v, estilo)
        for (x, y), car in zip(((x0, y0), (x1, y0), (x0, y1), (x1, y1)), esq):
            self.poner(x, y, car, estilo)

    def volcar(self):
        lineas = []
        for fila in self.celdas:
            linea, anterior = [], None
            for car, estilo in fila:
                if estilo != anterior:
                    linea.append(RESET + estilo)
                    anterior = estilo
                linea.append(car)
            lineas.append("".join(linea) + RESET)
        return "\n".join(lineas)


def estado(c):
    partes = []
    if c["workspace"]["name"].startswith("special:"):
        partes.append("scratchpad")
    if c["fullscreen"]:
        partes.append("pantalla completa")
    elif c["floating"]:
        partes.append("flotante")
    else:
        partes.append("mosaico")
    if c.get("pinned"):
        partes.append("fijada")
    if c.get("hidden"):
        partes.append("oculta")
    return ", ".join(partes)


def dibujar():
    columnas, filas = shutil.get_terminal_size((200, 60))
    monitores = sorted(hypr("monitors"), key=lambda m: m["x"])
    clientes = [c for c in hypr("clients") if c["mapped"] and c["class"] != CLASE_PROPIA]
    # Ventana con foco antes de abrir el mapa (el mapa se la quita): la de focusHistoryID más bajo
    activa = min(clientes, key=lambda c: c["focusHistoryID"])["address"] if clientes else None
    pos_mon = {m["id"]: i for i, m in enumerate(monitores)}   # orden de izquierda a derecha

    # Numeración: primero lo visible (monitor por monitor), luego el resto
    visibles = {}
    for m in monitores:
        ids = {m["activeWorkspace"]["id"]}
        if m.get("specialWorkspace", {}).get("id"):
            ids.add(m["specialWorkspace"]["id"])
        visibles[m["id"]] = ids
    def es_visible(c):
        return c["workspace"]["id"] in visibles.get(c["monitor"], set())
    orden = sorted(clientes, key=lambda c: (not es_visible(c), pos_mon.get(c["monitor"], 99),
                                            c["workspace"]["id"], c["at"][0], c["at"][1]))
    numero = {c["address"]: i + 1 for i, c in enumerate(orden)}
    color = {c["address"]: PALETA[i % len(PALETA)] for i, c in enumerate(orden)}

    # Escala: todos los monitores en una fila; una celda mide ~el doble de alta que de ancha
    total_px = sum(m["width"] for m in monitores)
    escala = (columnas - 2 * len(monitores) - 1) / total_px
    alto_mapa = int(max(m["height"] for m in monitores) * escala / 2.1) + 3
    lienzo = Lienzo(columnas, alto_mapa)

    x_cel = 0
    for m in monitores:
        ancho_c = int(m["width"] * escala)
        alto_c = int(m["height"] * escala / 2.1)
        x0, y0, x1, y1 = x_cel, 1, x_cel + ancho_c + 1, 1 + alto_c + 1
        foco = m["focused"]
        lienzo.caja(x0, y0, x1, y1, rgb(TEXTO if foco else BORDE_MON), doble=foco)
        ws = m["activeWorkspace"]["name"]
        especial = m.get("specialWorkspace", {}).get("name", "")
        cab = f" {m['name']} · escritorio {ws}" + (" + scratchpad" if especial else "") + " "
        lienzo.texto(x0 + 2, 0, cab, NEGRITA + rgb(TEXTO if foco else TENUE), maximo=ancho_c - 2)

        def a_celdas(c):
            ax = x0 + 1 + int((c["at"][0] - m["x"]) * escala)
            ay = y0 + 1 + int((c["at"][1] - m["y"]) * escala / 2.1)
            bx = x0 + int((c["at"][0] + c["size"][0] - m["x"]) * escala)
            by = y0 + int((c["at"][1] + c["size"][1] - m["y"]) * escala / 2.1)
            return max(ax, x0 + 1), max(ay, y0 + 1), min(max(bx, ax + 3), x1 - 1), min(max(by, ay + 2), y1 - 1)

        # Orden de pintado: mosaico, flotantes (la más reciente encima), pantalla completa, scratchpad
        def capa(c):
            return (c["workspace"]["name"].startswith("special:"), bool(c["fullscreen"]),
                    c["floating"], -c["focusHistoryID"])
        for c in sorted((c for c in clientes if c["monitor"] == m["id"] and es_visible(c)), key=capa):
            ax, ay, bx, by = a_celdas(c)
            col = color[c["address"]]
            es_activa = c["address"] == activa
            lienzo.caja(ax, ay, bx, by, rgb(col) + (NEGRITA if es_activa else ""), doble=es_activa)
            hueco = bx - ax - 1
            lienzo.texto(ax + 1, ay + 1, f"{numero[c['address']]} {c['class']}", NEGRITA + rgb(col), maximo=hueco)
            if by - ay > 2:
                lienzo.texto(ax + 1, ay + 2, estado(c), rgb(TENUE), maximo=hueco)
            if by - ay > 3:
                lienzo.texto(ax + 1, ay + 3, c["title"], rgb(TEXTO), maximo=hueco)
        x_cel = x1 + 1

    salida = [lienzo.volcar(), ""]

    # Lista: visible por monitor, luego otros escritorios y scratchpad
    nombre_mon = {m["id"]: m["name"] for m in monitores}
    grupo_actual = None
    for c in orden:
        if es_visible(c):
            grupo = f"Visible en {nombre_mon.get(c['monitor'], '?')}"
        elif c["workspace"]["name"].startswith("special:"):
            grupo = "Scratchpad (escondidas: SUPER+S para verlas)"
        else:
            grupo = f"Escritorio {c['workspace']['name']} (no visible, en {nombre_mon.get(c['monitor'], '?')})"
        if grupo != grupo_actual:
            salida.append(f"{NEGRITA}{rgb(TEXTO)}{grupo}{RESET}")
            grupo_actual = grupo
        marca = "▶" if c["address"] == activa else " "
        col = color[c["address"]]
        titulo = c["title"][: max(10, columnas - 60)]
        salida.append(f" {marca}{rgb(col)}{NEGRITA}{numero[c['address']]:>3}{RESET} {rgb(col)}{c['class']:<22.22}{RESET}"
                      f" {rgb(TENUE)}{estado(c):<26}{RESET} {titulo}")
    salida.append("")
    salida.append(f"{rgb(TENUE)}Doble borde = ventana con foco / monitor con foco · Flotantes dibujadas encima, la más reciente arriba{RESET}")
    return "\n".join(salida), {n: a for a, n in numero.items()}


def main():
    while True:
        texto, por_numero = dibujar()
        sys.stdout.write("\033[2J\033[H" + texto + "\n")
        try:
            eleccion = input(f"{NEGRITA}Número + Enter = ir a la ventana · Enter = refrescar · q = salir: {RESET}").strip()
        except (EOFError, KeyboardInterrupt):
            return
        if eleccion.lower() == "q":
            return
        if eleccion.isdigit() and int(eleccion) in por_numero:
            direccion = por_numero[int(eleccion)]
            subprocess.run(["hyprctl", "dispatch", f'hl.dsp.focus({{ window = "address:{direccion}" }})'],
                           capture_output=True)
            return


if __name__ == "__main__":
    main()
