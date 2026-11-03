#!/usr/bin/env bash
# 关闭 scrcpy 并恢复系统动画、锁屏脚本
# 支持 Hyprland 中定义的 env = MYPHONE,<id>

set -e  # 出错即退出

#=============================
# 环境初始化
#=============================
DEVICE_ID=${MYPHONE:-""}
WINDOW_SIZE_FILE="$HOME/.config/scrcpy/window-size"

if [ -z "$DEVICE_ID" ]; then
    echo "❌ 环境变量 MYPHONE 未定义，请先设置："
    echo "   export MYPHONE=<你的设备ID>"
    exit 1
fi

echo "📱 当前设备 ID: $DEVICE_ID"

#=============================
# 封装 adb 命令
#=============================
adb_cmd() {
    adb -s "$DEVICE_ID" "$@"
}

#=============================
# 恢复动画速度
#=============================
restore_animations() {
    echo "🎨 恢复系统动画..."
    adb_cmd shell settings put global window_animation_scale 1
    adb_cmd shell settings put global transition_animation_scale 1
    adb_cmd shell settings put global animator_duration_scale 1
}

#=============================
# 锁屏并关闭 scrcpy
#=============================
stop_scrcpy() {
    echo "🔒 锁定屏幕..."
    adb_cmd shell input keyevent 26

    echo "🛑 关闭 scrcpy..."
    if pgrep -x "scrcpy" > /dev/null; then
        local window_size
        window_size=$(hyprctl clients -j | jq -r '.[] | select(.class | test("^scrcpy"; "i")) | .size | "\(.[0]) \(.[1])"' | head -n 1)
        if [ -n "$window_size" ]; then
            mkdir -p "$(dirname "$WINDOW_SIZE_FILE")"
            printf '%s\n' "$window_size" > "$WINDOW_SIZE_FILE"
        fi
        pkill scrcpy
        echo "✅ scrcpy 已关闭。"
    else
        echo "ℹ️ scrcpy 未在运行。"
    fi
}

#=============================
# 主流程
#=============================
restore_animations
stop_scrcpy

echo "🏁 所有操作完成。"
