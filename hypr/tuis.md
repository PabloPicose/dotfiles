# TUIs y comandos de terminal

Se abre con `SUPER+SHIFT+T` (otra vez o `q` para cerrar). Editable: apunta aquí lo que te interese y guarda con `:w`.

## Archivos y disco

| Comando | Uso principal |
|---|---|
| `yazi` | Explorador de archivos (vim: hjkl, vista previa de imágenes) |
| `gdu ~` | Qué ocupa espacio; `d` borra, `M` ordena por fecha, `--min-age 1y` lo viejo |
| `duf` | Espacio libre de cada disco montado |

## Buscar (lo que usa nvim/Telescope por dentro)

| Comando | Uso principal |
|---|---|
| `fd <nombre>` | Buscar archivos por nombre (mejor `find`: rápido, respeta `.gitignore`). `fd -H` incluye ocultos |
| `rg <texto>` | Buscar texto dentro de archivos (ripgrep, mejor `grep -r`). `rg -i` sin mayúsculas |
| `fzf` | Buscador difuso interactivo. `fd \| fzf`, `CTRL+R` historial, `CTRL+T` archivo |
| `nvim $(fzf)` | Elegir un archivo con fzf y abrirlo |

## Sistema

| Comando | Uso principal |
|---|---|
| `btop` | CPU, RAM, discos, red y procesos (matar con `k`) |
| `nmtui` | Conectar wifi / configurar red |
| `fastfetch` | Resumen del sistema |
| `paru` | Actualizar todo (repos + AUR); `paru <nombre>` busca e instala |

## Git

| Comando | Uso principal |
|---|---|
| `lazygit` | Git completo: stage, commit, ramas, rebase |
| `tig` | Ver historial y diffs |

## Utilidades

| Comando | Uso principal |
|---|---|
| `tldr <comando>` | Ejemplos rápidos de uso de un comando (mejor `man`) |
| `bat <archivo>` | `cat` con colores y números de línea |
| `eza -la --git` | `ls` con colores, iconos y estado de git |
| `jq` | Leer / filtrar JSON (`hyprctl clients -j \| jq`) |
| `tmux` | Sesiones y paneles en la terminal (prefix `CTRL+b`) |
| `micro` | Editor sencillo (atajos tipo `CTRL+S`, `CTRL+Q`) |

## Por probar (no instalados)

| Comando | Uso principal |
|---|---|
| `dua i` | Como gdu, en Rust; marcar varias cosas y borrarlas |
| `zoxide` (`z <carpeta>`) | `cd` que recuerda carpetas usadas |
| `atuin` | Historial de la shell con búsqueda |

## Mis notas

| Comando | Uso principal |
|---|---|
|  |  |
