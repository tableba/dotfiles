-- hyprland.lua

-- Set programs that you use
local terminal = "kitty"
local fileManager = "dolphin"
local menu = "rofi -show drun -theme $HOME/.config/rofi/config.rasi"

-- ---------- Autostart -----------
hl.on("hyprland.start", function()
  -- 1. Export Wayland environment variables to DBus and Systemd
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- 2. Clean up stale portal instances
  hl.exec_cmd("~/.config/hypr/scripts/reset-portals.sh")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("dunst")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("waybar")
end)

-- ---------- Environment Variables -----------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- ---------- Monitors -----------
hl.monitor({ output = "DP-1", mode = "1920x1080@144", position = "0x0", scale = 1 })

-- mirror
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "auto", scale = 1, mirror = "DP-1" })

-- not mirror
-- hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x0", scale = 1 })

-- ---------- Configuration Table -----------
hl.config({
  debug = {
    disable_logs = false
  },
  input = {
    kb_layout = "us",
    kb_variant = "altgr-intl",
    follow_mouse = 1,
    sensitivity = 0,
    repeat_delay = 200,
    repeat_rate = 30,
    touchpad = {
      natural_scroll = true
    }
  },
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 0,
    ["col.active_border"] = "rgba(245, 245, 245, 0.690)",
    ["col.inactive_border"] = "rgba(bbbbbbbb)",
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle"
  },
  decoration = {
    rounding = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,
    shadow = {
      enabled = false,
      range = 30,
      render_power = 3,
      color = "0x66000000"
    },
    blur = {
      enabled = true,
      new_optimizations = true,
      ignore_opacity = true
    }
  },
  animations = {
    enabled = true -- We leave the global toggle here, but define curves/animations below
  },
  dwindle = {
    preserve_split = true
  },
  master = {
    new_status = "master"
  },
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true
  }
})

-- ---------- Devices -----------
hl.device({
  name = "logitech-gaming-mouse-g502",
  accel_profile = "flat",
  sensitivity = -0.3
})

hl.device({
  name = "logitech-mx-anywhere-2-1",
  accel_profile = "flat",
  sensitivity = -0.1
})

hl.device({
  name = "mx-anywhere-2-mouse",
  accel_profile = "flat",
  sensitivity = 0.1
})

-- ---------- Curves & Animations -----------
-- Curves (Bezier points are mapped as { {X0, Y0}, {X1, Y1} })
hl.curve("nothing", { type = "bezier", points = { { 0, 0 }, { 0, 0 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })

-- Animations
hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "nothing", style = "popin 100%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1, bezier = "nothing", style = "popin 100%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "nothing", style = "popin 100%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1, bezier = "nothing", style = "popin 100%" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "nothing" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "md3_decel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "easeOutExpo", style = "fade" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 1, bezier = "nothing", style = "fade" })

-- ---------- Window Rules -----------
hl.window_rule({
  match = { workspace = "w[tv1]" },
  name = "no-gaps-wtv1",
  border_size = 0
})

-- Add this rule for Kitty:
hl.window_rule({
  match = { class = "kitty" },
  name = "no-border-kitty",
  border_size = 0
})

-- ---------- Binds -----------
local mainMod = "SUPER"

-- Core operations
hl.bind(mainMod .. "+Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. "+SHIFT+Return", hl.dsp.exec_cmd(terminal .. " --class floating_terminal"))
hl.bind(mainMod .. "+Q", hl.dsp.window.close())
hl.bind(mainMod .. "+M", hl.dsp.exit())
hl.bind(mainMod .. "+E", hl.dsp.exec_cmd(fileManager))
-- hl.bind(mainMod .. "+D", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. "+F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. "+space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. "+P", hl.dsp.window.pseudo())

-- Tools and utilities
-- hl.bind(mainMod .. "+I", hl.dsp.exec_cmd("hyprshade toggle invert"))
hl.bind(mainMod .. "+SHIFT+U", hl.dsp.exec_cmd("hyprshot -m region output --clipboard-only"))
hl.bind(mainMod .. "+C", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- Move focus
hl.bind(mainMod .. "+H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. "+L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. "+K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. "+J", hl.dsp.focus({ direction = "down" }))

-- ---------- Floating Toggle with Size & Center -----------
hl.bind(mainMod .. "+D", function()
  local window = hl.get_active_window()
  if not window then return end

  if window.floating then
    -- If it's already floating, turn it back to tiled
    hl.dispatch(hl.dsp.window.float({ action = "unset", window = window }))
  else
    -- If it's tiled, make it float, resize it, and center it
    hl.dispatch(hl.dsp.window.float({ action = "set", window = window }))
    hl.dispatch(hl.dsp.window.resize({ x = 1200, y = 800, window = window })) -- Change these pixel values to your preferred size
    hl.dispatch(hl.dsp.window.center({ window = window }))
  end
end)

-- Hide a window
hl.bind("SUPER + S", function()
  if hl.get_workspace("special:minimized") then
    hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
    hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
  else
    hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
    hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
  end
end)

-- Workspaces (1-10 mapping)
for i = 1, 10 do
  local key = i % 10
  local wsNum = i
  hl.bind(mainMod .. "+" .. key, hl.dsp.focus({ workspace = wsNum }))
  hl.bind(mainMod .. "+SHIFT+" .. key, hl.dsp.window.move({ workspace = wsNum }))
end

-- Mouse actions
hl.bind(mainMod .. "+mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. "+mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media / Hardware Binds
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { repeating = true, locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true, locked = true })
