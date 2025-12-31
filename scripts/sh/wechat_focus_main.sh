#!/usr/bin/env bash

# ---------- log level ----------
# 0 = silent
# 1 = info
# 2 = debug
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

log_level=0

while [[ "$1" == -* ]]; do
    case "$1" in
        -v)  log_level=1 ;;
        -vv) log_level=2 ;;
    esac
    shift
done

log_info()  { [[ $log_level -ge 1 ]] && echo "[wechat-focus][INFO] $*" >&2; }
log_debug() { [[ $log_level -ge 2 ]] && echo "[wechat-focus][DEBUG] $*" >&2; }

# ---------- ipc socket ----------
socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

log_info "start"
log_debug "socket=$socket"

# ---------- listen ----------
socat - UNIX-CONNECT:"$socket" | while read -r line; do
    log_debug "event raw: $line"

    [[ "$line" != closewindow* ]] && continue

    # closewindow>>ADDR
    closed_addr=$(echo "$line" | cut -d'>' -f3)
    log_debug "close addr=$closed_addr"

    sleep 0.05

    current_ws=$(hyprctl -j activeworkspace | jq -r '.id')
    log_debug "current workspace=$current_ws"

    main_window_address=$(hyprctl -j clients | jq -r --arg ws "$current_ws" '
        .[]
        | select(.class=="wechat")
        | select(.workspace.id == ($ws|tonumber))
        | select(.title | test("^微信"))
        | .address
    ' | head -n 1)

    if [[ -z "$main_window_address" ]]; then
        log_info "wechat main window not found"
        continue
    fi

    log_info "focus wechat main window: $main_window_address"
    hyprctl dispatch focuswindow address:$main_window_address
    cursor_pos=$(hyprctl -j cursorpos)
    cursor_x=$(echo "$cursor_pos" | jq -r '.x')
    cursor_y=$(echo "$cursor_pos" | jq -r '.y')
    
    # 向右移动 1 像素
    hyprctl dispatch movecursor $((cursor_x + 1)) $cursor_y
    sleep 0.01
    hyprctl dispatch movecursor $((cursor_x - 1)) $cursor_y

done

