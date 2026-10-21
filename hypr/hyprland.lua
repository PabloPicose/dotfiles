-- Hyprland 0.56 (Lua config)
-- Basado en /usr/share/hypr/hyprland.lua
-- Wiki: https://wiki.hypr.land/Configuring/Start/
--
-- Atajos con SUPER para no chocar con kitty (ctrl+shift / alt), tmux ni nvim.
-- Salida de emergencia: SUPER + SHIFT + E


------------------
---- MONITORS ----
------------------

-- Misma disposición que en KDE (izquierda a derecha)
hl.monitor({ output = "DP-2", mode = "2560x1440@180", position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-1", mode = "3440x1440@165", position = "2560x0", scale = 1 })
hl.monitor({ output = "DP-3", mode = "1920x1080@144", position = "6000x0", scale = 1 })
-- Cualquier otro monitor que conectes
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local teams       = 'firefox --profile "$HOME/.config/mozilla/firefox/6pC8qnyy.Profile 1" --new-window https://teams.microsoft.com'
local fileManager = "dolphin"
local menu        = "fuzzel"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    -- Ventanas de contraseña para apps gráficas (Dolphin como admin, etc.)
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    -- Fondo de pantalla (~/.config/hypr/hyprpaper.conf) y barra (~/.config/waybar)
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("~/.config/hypr/scripts/waybar.sh")   -- se relanza solo si se cae
    -- Notificaciones (~/.config/mako/config)
    hl.exec_cmd("mako")
    -- Historial del portapapeles: guarda todo lo copiado (texto e imágenes)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- Apagar pantallas por inactividad (~/.config/hypr/hypridle.conf)
    hl.exec_cmd("hypridle")
    -- Montar USB / discos al conectarlos (en KDE lo hace Plasma). Icono en la bandeja solo si hay alguno.
    hl.exec_cmd("udiskie --automount --notify --smart-tray --appindicator")
    -- Iconos de bandeja X11 antiguos (XEmbed: Wine/Proton, Battle.net…) → bandeja de waybar (SNI).
    -- Sin esto Wine crea su propia ventanita blanca de bandeja. Viene con KDE (plasma-workspace).
    hl.exec_cmd("xembedsniproxy")
    -- Arctis Sound Manager: daemon (sin él no suenan los cascos) + icono en la bandeja.
    -- Sus servicios de systemd cuelgan de graphical-session.target, que KDE activa y Hyprland no → arrancarlos a mano.
    hl.exec_cmd("systemctl --user start arctis-manager.service app-ArctisManager.service")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NVIDIA: decodificación de vídeo por hardware (libva-nvidia-driver)
hl.env("LIBVA_DRIVER_NAME", "nvidia")

-- Apps Qt/KDE (Dolphin…) con el tema de Plasma (Breeze oscuro, iconos) como en KDE
hl.env("QT_QPA_PLATFORMTHEME", "kde")
-- Menú "Abrir con" de Dolphin (usa /etc/xdg/menus/plasma-applications.menu)
hl.env("XDG_MENU_PREFIX", "plasma-")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            -- Mismo azul que la pestaña activa de kitty
            active_border   = "rgba(7A9EC4ee)",
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        -- Oscurecer lo de detrás cuando el scratchpad (SUPER+S) está visible
        dim_special = 0.4,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Animaciones por defecto, un poco más rápidas
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1},  {0.32, 1} } })
hl.curve("linear",       { type = "bezier", points = { {0, 0},     {1, 1}    } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick",        { type = "bezier", points = { {0.15, 0},  {0.1, 1}  } })
hl.curve("easy",         { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global",     enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",     enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",    enabled = true, speed = 3.5,  spring = "easy" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 3,    spring = "easy",   style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",     enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
    -- Master (solo en DP-1, ver regla de escritorio abajo): principal en el centro al 50 %
    -- (también si está sola), el resto en columnas a los lados (con 1 sola extra, a la izquierda)
    master = {
        mfact = 0.5,
        slave_count_for_center_master = 0,
    },
})

-- DP-1 es ultrapanorámico (3440 px): layout master con la ventana principal en el centro.
-- DP-2 y DP-3 siguen con dwindle.
hl.workspace_rule({
    workspace   = "m[DP-1]",
    layout      = "master",
    layout_opts = { orientation = "center" },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,    -- sin fondos anime
        disable_hyprland_logo   = true,
        disable_splash_rendering = true, -- quita el texto aleatorio de abajo ("Help I forgot to install kitty"...)
        -- VRR (G-Sync/FreeSync) solo en pantalla completa de juegos/vídeo (content type), no de apps normales.
        -- Con 2 (cualquier pantalla completa) kitty/Firefox bajaban la frecuencia en reposo y al mover el ratón
        -- subía y bajaba → parpadeo (sobre todo en el VA de DP-1). Los juegos se marcan con content = "game" (regla "juegos").
        vrr = 3,
    },
})


---------------
---- INPUT ----
---------------

-- Mismas distribuciones que en KDE: us y es (winkeys)
hl.config({
    input = {
        kb_layout  = "us,es",
        kb_variant = ",winkeys",
        kb_options = "",

        -- 2 = como KDE: el ratón (scroll, hover) va a la ventana que tiene debajo, pero el foco del teclado
        -- no cambia hasta hacer clic. (0 = el ratón solo afectaba a la ventana con foco: no se podía hacer scroll en otra.)
        follow_mouse = 2,
        -- Por defecto (1), pasar de una ventana en mosaico a una flotante (o al revés) SÍ cambia el foco
        -- aunque follow_mouse ≠ 1 (popups de Steam/Battle.net, atajos…). 0 = solo teclado o clic.
        float_switch_override_focus = 0,
        sensitivity  = 0,
    },
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Programas
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
-- Lanzador: pulsar y soltar SUPER solo (como en KDE). En el Moonlander SUPER y Espacio
-- están los dos en el pulgar izquierdo, así que SUPER+Espacio era incómodo.
-- Volver a pulsarlo lo cierra. SUPER+D queda de reserva.
hl.bind(mainMod .. " + Super_L", hl.dsp.exec_cmd("pkill -x fuzzel || " .. menu), { release = true })
hl.bind(mainMod .. " + D",       hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))

-- Ventanas
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))    -- dwindle: vertical <-> horizontal
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Modo mitad (SUPER+Z): en el escritorio actual las ventanas ocupan solo media pantalla, aunque haya una sola
-- (siguen en mosaico dentro de esa mitad). Cada pulsación: completo → mitad derecha → mitad izquierda → completo.
-- Es un margen exterior (gaps_out) enorme en un lado, con reglas de escritorio que se activan/desactivan en caliente.
local mitadReglas = {}   -- ["<id>:<lado>:<ancho>"] = regla
local mitadEstado = {}   -- [id del escritorio] = nil | "derecha" | "izquierda"
local mitadSiguiente = { [""] = "derecha", derecha = "izquierda", izquierda = "" }

local function mitadRegla(ws, lado)
    local ancho = ws.monitor.width
    local clave = ws.id .. ":" .. lado .. ":" .. ancho
    if not mitadReglas[clave] then
        local mitad = math.floor(ancho / 2)
        mitadReglas[clave] = hl.workspace_rule({
            workspace = tostring(ws.id),
            gaps_out  = { top = 8, bottom = 8,
                          left  = lado == "derecha"   and mitad or 8,
                          right = lado == "izquierda" and mitad or 8 },
        })
    end
    return mitadReglas[clave]
end

-- Sin argumento: escritorio activo. Con un id (pruebas): `hyprctl dispatch 'modoMitad(9)'`.
function modoMitad(id)
    local ws = hl.get_active_workspace()
    if type(id) == "number" then
        for _, w in ipairs(hl.get_workspaces()) do if w.id == id then ws = w end end
    end
    if not ws or not ws.monitor then return end
    local actual = mitadEstado[ws.id] or ""
    if actual ~= "" then mitadRegla(ws, actual):set_enabled(false) end
    local nuevo = mitadSiguiente[actual]
    if nuevo ~= "" then mitadRegla(ws, nuevo):set_enabled(true) end
    mitadEstado[ws.id] = nuevo ~= "" and nuevo or nil
end

hl.bind(mainMod .. " + Z", function() modoMitad() end)

-- Salida de emergencia: cierra la sesión de Hyprland
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

-- Menú de energía (cerrar sesión / suspender / reiniciar / apagar)
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("~/.config/hypr/scripts/powermenu.sh"))

-- Buscador de ventanas: todas las ventanas abiertas en fuzzel (como Telescope buffers)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/windows.sh"))

-- Manual de atajos (manual.md): SUPER+A en nvim flotante (q sale) · SUPER+SHIFT+A buscar en fuzzel
hl.bind(mainMod .. " + A",         hl.dsp.exec_cmd("~/.config/hypr/scripts/atajos.sh"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/atajos-buscar.sh"))

-- Tecla líder para abrir apps (como <leader> en vim): SUPER+O y luego una letra.
-- Sale sola del modo tras abrir la app ("reset"); Esc cancela. Waybar muestra "-- abrir --".
hl.bind(mainMod .. " + O", hl.dsp.submap("abrir"))

hl.define_submap("abrir", "reset", function()
    hl.bind("F", hl.dsp.exec_cmd("firefox"))
    -- Microsoft Teams en el perfil de trabajo "indra". Es del gestor de perfiles nuevo (no está en
    -- profiles.ini), así que -P no lo encuentra: se abre por su carpeta. Si ya está abierto, añade una ventana.
    hl.bind("M", hl.dsp.exec_cmd(teams))
    hl.bind("D", hl.dsp.exec_cmd("discord"))
    hl.bind("S", hl.dsp.exec_cmd("steam"))
    hl.bind("C", hl.dsp.exec_cmd("code"))
    hl.bind("T", hl.dsp.exec_cmd(terminal))
    hl.bind("E", hl.dsp.exec_cmd(fileManager))
    hl.bind("K", hl.dsp.exec_cmd("keymapp"))
    hl.bind("V", hl.dsp.exec_cmd("pavucontrol"))

    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Layout master (DP-1): convertir la ventana activa en la principal (la del centro)
hl.bind(mainMod .. " + M", hl.dsp.layout("swapwithmaster"))

-- Historial del portapapeles (SUPER+V ya es flotante)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard.sh"))

-- Notificaciones: cerrar la última / todas
hl.bind(mainMod .. " + N",         hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("makoctl dismiss --all"))

-- Captura de una zona → directa al portapapeles, sin guardar archivo. Pegar con CTRL+V.
-- (Sin Impr Pant: en el Moonlander no se usa. cliphist también la guarda → SUPER+SHIFT+V)
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))

-- Cambiar distribución de teclado us <-> es (como Meta+Alt+K en KDE)
hl.bind(mainMod .. " + ALT + K", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))

-- Vim: mover foco (h/j/k/l)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Vim: mover ventana (SHIFT + h/j/k/l)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Modo resize (como un modo de vim): SUPER + R, luego h/j/k/l, salir con Escape o Enter
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("H", hl.dsp.window.resize({ x = -30, y = 0,   relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0,   y = 30,  relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0,   y = -30, relative = true }), { repeating = true })
    hl.bind("L", hl.dsp.window.resize({ x = 30,  y = 0,   relative = true }), { repeating = true })

    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
end)

-- Monitores (DP-2 | DP-1 | DP-3)
-- SUPER + h/l ya cruza de monitor al llegar al borde (como smart-splits en nvim).
-- SUPER + CTRL + h/l salta directo al monitor de al lado.
-- Hyper + h/l se lleva la ventana (Hyper = SUPER+CTRL+ALT+SHIFT, una sola tecla en el Moonlander).
local hyper = "SUPER + CTRL + ALT + SHIFT"
hl.bind(mainMod .. " + CTRL + H", hl.dsp.focus({ monitor = "left" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.focus({ monitor = "right" }))
hl.bind(hyper .. " + H",          hl.dsp.window.move({ monitor = "left" }))
hl.bind(hyper .. " + L",          hl.dsp.window.move({ monitor = "right" }))

-- Escritorios: SUPER + [0-9]; SUPER + SHIFT + [0-9] mueve la ventana
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Volver al escritorio anterior (como <C-^> en vim)
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Escritorio anterior / siguiente en el monitor actual, aunque esté vacío (como gT / gt en vim)
hl.bind(mainMod .. " + bracketleft",  hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ workspace = "r+1" }))

-- Scratchpad
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Ratón (por si acaso)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Teclas multimedia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    -- Ignore maximize requests from all apps
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Juegos: siempre en el monitor principal (DP-1) y a pantalla completa.
-- Los juegos de Steam con Proton tienen clase steam_app_<id>; los nativos de Linux usan su propio nombre.
-- Para añadir un juego nativo: abrirlo, mirar su clase con `hyprctl clients` y añadirla a la lista.
local juegosNativos = { "hoi4" }

hl.window_rule({
    name  = "juegos",
    match = { class = "^(steam_app_[0-9]+|" .. table.concat(juegosNativos, "|") .. ")$" },

    monitor      = "DP-1",
    fullscreen   = true,
    content      = "game",          -- activa el VRR (misc.vrr = 3)
    idle_inhibit = "fullscreen",   -- no apagar la pantalla mientras se juega
})

-- Juegos sin VRR: estrategia con FPS bajos y variables (al mover el ratón el mapa se redibuja y los FPS saltan)
-- → con VRR el panel VA de DP-1 cambia de brillo = parpadeo. Siguen en DP-1 a pantalla completa.
local juegosSinVrr = { "hoi4" }

hl.window_rule({
    name    = "juegos-sin-vrr",
    match   = { class = "^(" .. table.concat(juegosSinVrr, "|") .. ")$" },
    content = "none",
})

-- El launcher de Battle.net (Proton, acceso directo de Steam) también es steam_app_<id> y caía en "juegos":
-- pantalla completa + content game → VRR en DP-1 con una app que apenas repinta → parpadeo.
-- Se deshace para las ventanas "Battle.net…"; los juegos que abre (WoW…) comparten clase pero no título.
-- Fuera de Steam (umu-launcher, GAMEID=0) la clase es steam_app_0.
hl.window_rule({
    name       = "battlenet",
    match      = { class = "^steam_app_[0-9]+$", title = ".*Battle\\.net.*" },  -- launcher, "Configuración de Battle.net", login…
    fullscreen = false,
    content    = "none",
})

-- Menú del icono de la bandeja de Battle.net (clic derecho en waybar): Wine lo pinta desplazado +2560 px
-- (XWayland pone DP-1 en x=0 y Hyprland en x=2560) → aparecía en DP-3 o fuera de pantalla.
-- Es la única ventana flotante con título exacto "Battle.net" (launcher en mosaico; login/instalador tienen otro título).
-- Se pone a la izquierda del cursor (la bandeja está en el borde derecho).
hl.window_rule({
    name  = "battlenet-menu",
    match = { class = "^steam_app_[0-9]+$", title = "^Battle\\.net$", float = true },
    move  = "cursor_x-window_w cursor_y",
})

-- Cada app en su monitor (al abrirse). Discord no se fija: va donde esté el foco.
hl.window_rule({
    name    = "steam-dp3",
    match   = { class = "^steam$" },   -- el cliente; los juegos (steam_app_*) van a DP-1 con la regla "juegos"
    monitor = "DP-3",
})

hl.window_rule({
    name   = "atajos",                  -- manual de atajos (SUPER+A): flotante y centrado
    match  = { class = "^atajos$" },
    float  = true,
    size   = "monitor_w*0.7 monitor_h*0.85",
    center = true,
})

hl.window_rule({
    name    = "firefox-dp2",
    match   = { class = "^firefox$" }, -- incluye Teams en el navegador
    monitor = "DP-2",
})
