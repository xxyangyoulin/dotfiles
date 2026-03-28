#!/usr/bin/env bash

set -euo pipefail

SCRCPY_CLASS_REGEX="${SCRCPY_CLASS_REGEX:-^scrcpy$}"
SCRCPY_PAUSE_MODIFIERS="${SCRCPY_PAUSE_MODIFIERS:-ALT}"
SCRCPY_RESUME_MODIFIERS="${SCRCPY_RESUME_MODIFIERS:-ALT SHIFT}"
socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
SCRCPY_INPUT_METHOD="${SCRCPY_INPUT_METHOD:-keyboard-us}"
DEFAULT_INPUT_METHOD="${DEFAULT_INPUT_METHOD:-rime}"

is_scrcpy_class() {
    local class_name="$1"
    [[ "$class_name" =~ $SCRCPY_CLASS_REGEX ]]
}

sync_scrcpy_windows() {
    local current_ws clients_json

    current_ws="$(hyprctl activeworkspace -j | jq -r '.id')"
    clients_json="$(hyprctl clients -j)"

    mapfile -t scrcpy_windows < <(
        jq -r --arg re "$SCRCPY_CLASS_REGEX" '
            .[]
            | select((.class // "") | test($re))
            | "\(.address) \(.workspace.id)"
        ' <<<"$clients_json"
    )

    if [ "${#scrcpy_windows[@]}" -eq 0 ]; then
        return 0
    fi

    for window in "${scrcpy_windows[@]}"; do
        read -r address ws_id <<<"$window"

        if [ "$ws_id" = "$current_ws" ]; then
            hyprctl dispatch sendshortcut "${SCRCPY_RESUME_MODIFIERS}, z, address:${address}" >/dev/null
        else
            hyprctl dispatch sendshortcut "${SCRCPY_PAUSE_MODIFIERS}, z, address:${address}" >/dev/null
        fi
    done
}

handle_active_window() {
    local active_class

    active_class="$(hyprctl activewindow -j | jq -r '.class // ""')"

    if is_scrcpy_class "$active_class"; then
        fcitx5-remote -s "$SCRCPY_INPUT_METHOD" >/dev/null
    else
        fcitx5-remote -s "$DEFAULT_INPUT_METHOD" >/dev/null
    fi
}

sync_scrcpy_windows
handle_active_window

socat -U - UNIX-CONNECT:"$socket" | while read -r line; do
    case "$line" in
        workspacev2*|focusedmonv2*)
            sync_scrcpy_windows
            ;;
        activewindow*|activewindowv2*)
            handle_active_window
            ;;
    esac
done
