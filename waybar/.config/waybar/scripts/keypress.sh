#!/bin/bash

# 确保环境变量存在
if [ -z "$XDG_RUNTIME_DIR" ] || [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "ERROR: Hyprland environment variables not set!" >&2
    exit 1
fi

SOCKET_PATH="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# 检查Socket文件是否存在
if [ ! -S "$SOCKET_PATH" ]; then
    echo "ERROR: Hyprland socket not found at $SOCKET_PATH" >&2
    exit 1
fi

# 实时监听键盘事件
socat -U - "UNIX-CONNECT:$SOCKET_PATH" | while read -r line; do
    if [[ "$line" == *"keyboard"* ]]; then
        # 获取当前按下的键（示例：仅显示第一个按下的键）
        hyprctl binds -j | jq -r '.[] | select(.locked == false) | .key' | head -n 1
    fi
done
