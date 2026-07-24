local mod = "SUPER"

local function exec_once(cmd)
	hl.on("hyprland.start", function()
		hl.exec_cmd(cmd)
	end)
end

local function bind_exec(keys, cmd, opts)
	hl.bind(keys, hl.dsp.exec_cmd(cmd), opts or {})
end

local function bind_dispatch(keys, dispatcher, opts)
	hl.bind(keys, function()
		hl.dispatch(dispatcher)
	end, opts or {})
end

local function bind_focus(keys, direction)
	hl.bind(keys, hl.dsp.focus({ direction = direction }))
end

local function bind_workspace(keys, workspace)
	hl.bind(keys, hl.dsp.focus({ workspace = workspace }))
end

local function bind_move_window(keys, direction)
	hl.bind(keys, hl.dsp.window.move({ direction = direction }))
end

local function bind_move_workspace(keys, workspace)
	hl.bind(keys, hl.dsp.window.move({ workspace = workspace }))
end

local function window_rule(name, match, effects)
	local rule = { name = name, match = match }
	for key, value in pairs(effects) do
		rule[key] = value
	end
	hl.window_rule(rule)
end

local function layer_rule(name, match, effects)
	local rule = { name = name, match = match }
	for key, value in pairs(effects) do
		rule[key] = value
	end
	hl.layer_rule(rule)
end

hl.env("GTK_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("WLR_DRM_NO_ATOMIC", "1")
hl.env("LIBVA_DRIVER_NAME", "iHD")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "mesa")
hl.env("MESA_LOADER_DRIVER_NAME", "iris")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("MYPHONE", "ed546061")
hl.env("LANG", "zh_CN.UTF-8")
hl.env("LANGUAGE", "zh_CN:zh:en_US:en")
hl.env("LC_ALL", "zh_CN.UTF-8")
hl.env("HYPRCURSOR_THEME", "Uos-fulldistro-icons-Dark")
hl.env("XCURSOR_THEME", "Uos-fulldistro-icons-Dark")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
		use_nearest_neighbor = false,
	},
	input = {
		kb_layout = "us",
		numlock_by_default = true,
		follow_mouse = 0,
		float_switch_override_focus = 0,
	},
	cursor = {
		no_warps = true,
		min_refresh_rate = 50,
		no_hardware_cursors = false,
		hide_on_key_press = true,
	},
	general = {
		gaps_in = 3,
		gaps_out = 3,
		border_size = 2,
		col = {
			active_border = "rgb(d1d0d0)",
			inactive_border = "rgb(586274)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "master",
	},
	decoration = {
		rounding = 10,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 15,
			render_power = 3,
			color = "rgba(00000033)",
		},
		blur = {
			enabled = true,
			size = 4,
			passes = 3,
			new_optimizations = true,
			noise = 0.0,
			contrast = 1.0,
			brightness = 1.0,
		},
	},
	group = {
		groupbar = {
			indicator_height = 0,
			font_size = 12,
			font_weight_active = "bold",
			blur = false,
			gradients = true,
			font_family = "SourceHanSerifCN",
			col = {
				active = "rgba(00000000)",
				inactive = "rgba(22000000)",
			},
			keep_upper_gap = false,
		},
	},
	animations = {
		enabled = true,
	},
	dwindle = {
		preserve_split = true,
		force_split = 2,
	},
	master = {
		orientation = "left",
		mfact = 0.65,
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 1,
		allow_session_lock_restore = 1,
		focus_on_activate = true,
		enable_swallow = false,
		mouse_move_enables_dpms = false,
		disable_autoreload = true,
	},
})

hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3, bezier = "default", style = "slide 10%" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3, bezier = "default", style = "slidefade 10%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "default" })

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

exec_once("systemctl --user import-environment --all")
exec_once("dbus-update-activation-environment --systemd --all")
exec_once("sleep 2 && DISPLAY=:0 fcitx5 -r -d")
exec_once("systemctl --user start hyprland-session.target")
exec_once("xrdb -merge ~/.Xresources")
exec_once("flclash")
exec_once("udiskie &")
exec_once('bash -c "wl-paste --watch cliphist store &"')
exec_once("wl-paste --type text --watch cliphist store")
exec_once("wl-paste --type image --watch cliphist store")
exec_once("kdeconnectd")
exec_once("kdeconnect-indicator")
exec_once("rustdesk")
exec_once("~/sh/wechat_focus_main.sh")
exec_once("~/sh/scrcpy_workspace_sync.sh")
exec_once("vicinae server")
exec_once("hypridle")
exec_once("pot")
exec_once("~/.config/hypr/local_custom/mem_alert.sh")
exec_once("phpbox --hide &!")

window_rule("tile-window", { class = "^(org\\.wezfurlong\\.wezterm|gnome-control-center|pavucontrol|nm-connection-editor)$" }, {})
window_rule("border-1", { class = "^(kitty|wechat)$" }, {})
window_rule("dms-float", { class = "^(com.danklinux.dms)$" }, { float = true })
window_rule("gnome-rounding", { class = "^(org\\.gnome\\.)" }, { rounding = 12 })
window_rule("gnome-border", { class = "^(org\\.gnome\\.)" }, { border_size = 0 })
window_rule("fcitx", { class = "^(fcitx.*)$" }, { float = true, border_size = 0, no_blur = true, no_focus = true })
window_rule("waydroid", { class = "^(Waydroid.*|waydroid.*)$" }, { float = true, border_size = 0, no_blur = true })
window_rule("suppress-maximize", { class = ".*" }, { suppress_event = "maximize" })
window_rule("fix-xwayland-drags", { xwayland = true, float = true, fullscreen = false, pin = false, title = "^$", class = "^$" }, { no_focus = true })
window_rule("no-gaps-tv", { workspace = "w[t1]", float = false }, { border_size = 0 })
window_rule("quickshell-float", { class = "^(org.quickshell)$" }, { float = true })
window_rule("fix-wechat", { class = "wechat", title = "negative:^(朋友圈|微信|设置|聊天文件|预览|图片和视频)\\W*" }, { no_blur = true, no_shadow = true, border_size = 0 })
window_rule("fix-wechat-send", { class = "wechat", title = "^微信发送给$" }, { no_blur = true, no_shadow = true, border_size = 0 })

local class_rules = {
	{ "file-roller", "^(org\\.gnome\\.FileRoller)", { float = true } },
	{ "gnome-calculator", "^(gnome-calculator)$", { float = true } },
	{ "galculator", "^(galculator)$", { float = true } },
	{ "cc-switch", "^(cc-switch)$", { float = true } },
	{ "evolution", "^(org.gnome.Evolution)$", { float = true } },
	{ "blueman-manager", "^(blueman-manager)$", { float = true } },
	{ "nautilus-float", "^(org\\.gnome\\.Nautilus)$", { float = true } },
	{ "telegram", "^(org\\.telegram\\.desktop)$", { float = true } },
	{ "steam", "^(steam)$", { float = true } },
	{ "xdg-desktop-portal", "^(xdg-desktop-portal)$", { float = true } },
	{ "follow-clash", "^(com.follow.clash)$", { float = true } },
	{ "wezterm-border", "^(org\\.wezfurlong\\.wezterm)$", { border_size = 0 } },
	{ "alacritty-border", "^(Alacritty)$", { border_size = 0 } },
	{ "zen-border", "^(zen)$", { border_size = 0 } },
	{ "ghostty-border", "^(com\\.mitchellh\\.ghostty)$", { border_size = 0 } },
	{ "zoom", "^(zoom)$", { float = true } },
	{ "scrcpy", "^(scrcpy.*)$", { float = true } },
	{ "mpv", "^(mpv.*)$", { float = true } },
	{ "overskride", "^(io.github.kaii_lb.Overskride.*)$", { float = true } },
	{ "pavucontrol", "^(org.pulseaudio.pavucontrol.*)$", { float = true } },
	{ "nm", "^(nm-connection-editor.*)$", { float = true } },
	{ "qbittorrent", "^(qBittorrent.*)$", { float = true } },
	{ "qq", "^(QQ.*)$", { float = true } },
	{ "rustdesk", "^(rustdesk.*)$", { float = true } },
	{ "satty", "^(satty.*)$", { pin = true } },
	{ "crow", "^(crow-translate.*)$", { float = true } },
	{ "netease", "^(netease-cloud-music.*)$", { float = true } },
	{ "pot-float", "^(Pot.*)$", { float = true } },
	{ "flclash", "^(flclash.*)$", { float = true } },
	{ "xdg-portal-gtk", "^(xdg-desktop-portal-gtk.*)$", { float = true } },
	{ "copyq-float", "^(copyq)$", { float = true } },
	{ "kruler", "^(org.kde.kruler)$", { float = true } },
	{ "pot-lower", "^(pot)$", { float = true } },
	{ "swappy", "^(swappy)$", { pin = true, no_blur = true } },
	{ "xunlei", "^(com.xunlei.download)$", { no_blur = true } },
	{ "apifox-workspace", "^(apifox)$", { workspace = "3 silent" } },
	{ "js-design-workspace", "^(即时设计)$", { workspace = "5 silent" } },
	{ "kitty-opacity", "^(kitty)$", { opacity = "0.9 0.9" } },
	{ "wechat-opacity", "^(wechat)$", { opacity = "0.97 0.97" } },
	{ "wechat-border", "^(wechat)$", { border_color = "rgb(07C160) rgb(A3D9D1)" } },
	{ "wechat-float", "^(wechat)$", { float = true } },
	{ "phpbox-float", "^(phpbox)$", { float = true } },
	{ "claude-float", "^(Claude)$", { float = true } },
	{ "chatgpt-float", "^(chrome-cadlkienfkclaiaibeoongdcgmdikeeg-Profile_7)$", { float = true } },
	{ "chatgpt2-float", "^(chrome-fmpnliohjhemenmnlpbfagaolkdacoja-Profile_7)$", { float = true } },
	{ "explorer-special", "^(explorer\\.exe)$", { workspace = "special silent" } },
	{ "explorer-no-focus", "^(explorer\\.exe)$", { no_focus = true } },
}

for _, rule in ipairs(class_rules) do
	window_rule(rule[1], { class = rule[2] }, rule[3])
end

window_rule("firefox-pip", { class = "^(firefox)$", title = "^(Picture-in-Picture)$" }, { float = true })
window_rule("pot-tools", { class = "^(pot)$", title = "(Translator|OCR|PopClip|Screenshot Translate)" }, { float = true })
window_rule("pot-move", { class = "^(pot)$", title = "(Translator|PopClip|Screenshot Translate)" }, { move = { "cursor_x", "cursor_y" } })
window_rule("pot-size", { class = "^(pot)$" }, { size = { 520, 1000 } })
window_rule("copyq-size", { class = "^(copyq)$" }, { size = { 320, 500 } })
window_rule("copyq-move", { class = "^(copyq)$" }, { move = { "cursor_x", "cursor_y" } })
window_rule("nautilus-size", { class = "^(org\\.gnome\\.Nautilus)$" }, { size = { 1200, 800 } })
window_rule("pip-float", { title = "(Picture-in-Picture|画中画)" }, { float = true })
window_rule("pip-pin", { title = "(Picture-in-Picture|画中画)" }, { pin = true })
window_rule("pip-size", { title = "(Picture-in-Picture|画中画)" }, { size = { 640, 360 } })
window_rule("pip-move", { title = "(Picture-in-Picture|画中画)" }, { move = { "monitor_w-660", "monitor_h-390" } })
window_rule("claude-size", { class = "^(Claude)$" }, { size = { 900, 900 } })
window_rule("chatgpt-size", { class = "^(chrome-cadlkienfkclaiaibeoongdcgmdikeeg-Profile_7)$" }, { size = { 900, 900 } })
window_rule("chatgpt2-size", { class = "^(chrome-fmpnliohjhemenmnlpbfagaolkdacoja-Profile_7)$" }, { size = { 900, 900 } })
window_rule("chatgpt-special", { class = "^(chrome-cadlkienfkclaiaibeoongdcgmdikeeg-Profile_7)$" }, { workspace = "special:chatgpt silent" })

hl.workspace_rule({ workspace = "w[t1]", gaps_out = 0, gaps_in = 0 })

layer_rule("vicinae-blur", { namespace = "vicinae" }, { blur = false, ignore_alpha = 0.2, no_anim = false })
layer_rule("dms-pop", { namespace = "^(dms:.*)$" }, { blur = true, animation = "fade", ignore_alpha = 0 })

bind_exec(mod .. " + O", "hyprctl clients >~/.layers")
bind_exec(mod .. " + return", "kitty")
bind_exec(mod .. " + SHIFT + S", "dms ipc call settings toggle")
bind_exec(mod .. " + SHIFT + N", "dms ipc call notepad toggle")
bind_exec(mod .. " + space", "dms ipc call spotlight toggle")
bind_exec(mod .. " + V", "dms ipc call clipboard toggle")
bind_exec(mod .. " + ALT + V", "dms ipc call clipboardPlus togglePanel")
bind_exec(mod .. " + SHIFT + M", "dms ipc call processlist focusOrToggle")
bind_exec(mod .. " + N", "dms ipc call notifications toggle")
bind_exec(mod .. " + E", "hyptg nautilus org.gnome.Nautilus")
bind_exec(mod .. " + SHIFT + G", "dms ipc call tray activate netease-cloud-music-web-player_status_icon_1")
bind_exec("ALT + D", "wl-paste --primary | curl -s -X POST http://127.0.0.1:60828/ --data-binary @-")
bind_exec("ALT + S", 'grim -g "$(slurp)" ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png && curl "127.0.0.1:60828/ocr_translate?screenshot=false"')
bind_exec(mod .. " + M", "dms ipc call keybinds toggle hyprland")
bind_exec(mod .. " + F8", "/home/yyl/sh/startscrcpy.sh")
bind_exec(mod .. " + F10", "/home/yyl/sh/unlockphone.sh")
bind_exec(mod .. " + F9", "/home/yyl/sh/killscrcpy.sh")
bind_exec(mod .. " + F1", "adb -s ed546061 shell input keyevent KEYCODE_HOME")
bind_exec(mod .. " + ALT + F", "dms ipc call quickCapture screenshot region edit")
bind_exec(mod .. " + CTRL + 4", 'grim -g "$(slurp)" - | wl-copy')
bind_exec(mod .. " + CTRL + G", "hyprpicker | wl-copy")
bind_exec(mod .. " + ALT + M", 'notify-send "Window Class" "$(hyprctl activewindow | grep "class:")" && hyprctl activewindow | grep "class:" | awk "{print \\$2}" | wl-copy')
bind_exec(mod .. " + CTRL + M", 'notify-send "Window Title" "$(hyprctl activewindow)" && hyprctl activewindow | wl-copy')
bind_exec(mod .. " + X", "dms ipc call lock lock; /home/yyl/sh/killscrcpy.sh")
bind_exec("CTRL + ALT + Delete", "dms ipc call processlist focusOrToggle")

bind_exec("XF86AudioRaiseVolume", "dms ipc call audio increment 3", { locked = true, repeating = true })
bind_exec("XF86AudioLowerVolume", "dms ipc call audio decrement 3", { locked = true, repeating = true })
bind_exec("XF86AudioMute", "dms ipc call audio mute", { locked = true })
bind_exec("XF86AudioMicMute", "dms ipc call audio micmute", { locked = true })
bind_exec("XF86AudioNext", "playerctl next", { locked = true })
bind_exec("XF86AudioPause", "playerctl play-pause", { locked = true })
bind_exec("XF86AudioPlay", "playerctl play-pause", { locked = true })
bind_exec("XF86AudioPrev", "playerctl previous", { locked = true })
bind_exec(mod .. " + F11", "/home/yyl/sh/dd-incbr.sh")
bind_exec(mod .. " + F12", "/home/yyl/sh/dd-decbr.sh")
bind_exec("XF86MonBrightnessUp", 'dms ipc call brightness increment 5 ""', { locked = true, repeating = true })
bind_exec("XF86MonBrightnessDown", 'dms ipc call brightness decrement 5 ""', { locked = true, repeating = true })

bind_exec(mod .. " + W", "/home/yyl/.config/hypr/scripts/dms-aware-close.sh")
bind_exec(mod .. " + SHIFT + W", "hyprctl kill")
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + T", hl.dsp.window.move({ workspace = "special:minimized" }))
hl.bind(mod .. " + SHIFT + T", function()
	hl.dispatch(hl.dsp.workspace.toggle_special("minimized"))
	hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
end)
hl.bind(mod .. " + S", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + Y", hl.dsp.group.toggle())
hl.bind(mod .. " + Z", hl.dsp.group.next())
hl.bind(mod .. " + U", hl.dsp.group.next())
hl.bind(mod .. " + SHIFT + U", hl.dsp.window.move({ out_of_group = true }))
hl.bind(mod .. " + ALT + Y", hl.dsp.group.lock_active({ action = "toggle" }))
hl.bind(mod .. " + D", hl.dsp.layout("swapwithmaster master"))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
hl.bind(mod .. " + SHIFT + C", hl.dsp.window.center())
bind_focus(mod .. " + H", "left")
bind_focus(mod .. " + J", "down")
bind_focus(mod .. " + K", "up")
bind_focus(mod .. " + L", "right")
bind_move_window(mod .. " + SHIFT + H", "left")
bind_move_window(mod .. " + SHIFT + J", "down")
bind_move_window(mod .. " + SHIFT + K", "up")
bind_move_window(mod .. " + SHIFT + L", "right")
hl.bind(mod .. " + Home", hl.dsp.layout("focusmaster master"))
hl.bind(mod .. " + End", hl.dsp.focus({ last = true }))
bind_workspace("SUPER + Tab", "previous")
bind_move_workspace(mod .. " + SHIFT + Page_Down", "e+1")
bind_move_workspace(mod .. " + SHIFT + Page_Up", "e-1")
bind_move_workspace(mod .. " + SHIFT + I", "e-1")
bind_workspace(mod .. " + mouse_down", "e+1")
bind_workspace(mod .. " + mouse_up", "e-1")
bind_move_workspace(mod .. " + CTRL + mouse_down", "e+1")
bind_move_workspace(mod .. " + CTRL + mouse_up", "e-1")

for i = 1, 10 do
	local key = i % 10
	bind_workspace(mod .. " + " .. key, i)
	bind_move_workspace(mod .. " + SHIFT + " .. key, i)
end

hl.bind(mod .. " + bracketleft", hl.dsp.layout("preselect l"))
hl.bind(mod .. " + bracketright", hl.dsp.layout("preselect r"))
hl.bind(mod .. " + CTRL + F", function()
	hl.dispatch("resizeactive exact 100%")
end)
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
bind_dispatch(mod .. " + code:20", "resizeactive -100 0", { description = "Expand window left" })
bind_dispatch(mod .. " + code:21", "resizeactive 100 0", { description = "Shrink window left" })
bind_dispatch(mod .. " + minus", "resizeactive -10% 0", { repeating = true })
bind_dispatch(mod .. " + equal", "resizeactive 10% 0", { repeating = true })
bind_dispatch(mod .. " + SHIFT + minus", "resizeactive 0 -10%", { repeating = true })
bind_dispatch(mod .. " + SHIFT + equal", "resizeactive 0 10%", { repeating = true })
bind_exec("Print", "dms screenshot")
bind_exec("CTRL + Print", "dms screenshot full")
bind_exec("ALT + Print", "dms screenshot window")
hl.bind(mod .. " + SHIFT + p", hl.dsp.exit())
bind_exec(mod .. " + SHIFT + r", "dms restart")
bind_exec(mod .. " + CTRL + up", "dms restart")
bind_exec(mod .. " + G", "~/.config/hypr/local_custom/toggle_wechat.sh")
bind_exec(mod .. " + A", "hyptg claude-desktop Claude")
bind_exec(mod .. " + B", "dms ipc call plugins toggle aiAssistant")
