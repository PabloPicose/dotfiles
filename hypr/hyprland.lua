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
local fileManager = "dolphin"
local menu        = "fuzzel"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
    -- Ventanas de contraseña para apps gráficas (Dolphin como admin, etc.)
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NVIDIA: decodificación de vídeo por hardware (libva-nvidia-driver)
hl.env("LIBVA_DRIVER_NAME", "nvidia")


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
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,    -- sin fondos anime
        disable_hyprland_logo   = true,
        disable_splash_rendering = true, -- quita el texto aleatorio de abajo ("Help I forgot to install kitty"...)
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

        follow_mouse = 1,
        sensitivity  = 0,
    },
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Programas
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + space",  hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))

-- Ventanas
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))    -- dwindle: vertical <-> horizontal
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Salida de emergencia: cierra la sesión de Hyprland
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

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

-- Monitores: SUPER + , / . mueve el foco; con SHIFT mueve la ventana
hl.bind(mainMod .. " + comma",          hl.dsp.focus({ monitor = "left" }))
hl.bind(mainMod .. " + period",         hl.dsp.focus({ monitor = "right" }))
hl.bind(mainMod .. " + SHIFT + comma",  hl.dsp.window.move({ monitor = "left" }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "right" }))

-- Escritorios: SUPER + [0-9]; SUPER + SHIFT + [0-9] mueve la ventana
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Volver al escritorio anterior (como <C-^> en vim)
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Escritorio anterior / siguiente del monitor actual (como [b / ]b en vim)
hl.bind(mainMod .. " + bracketleft",  hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ workspace = "m+1" }))

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
