#!/usr/bin/env bash
# 自动启动 scrcpy 并解锁手机脚本
# 支持 Hyprland 中定义的 env = MYPHONE,<id>

set -e  # 出错时退出脚本

#=============================
# 初始化与环境检测
#=============================
DEVICE_ID=${MYPHONE:-""}

if [ -z "$DEVICE_ID" ]; then
    echo "❌ 环境变量 MYPHONE 未定义，请在 Hyprland 或当前终端中设置："
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
# 启动 scrcpy
#=============================
start_scrcpy() {
    echo "🚀 启动 scrcpy..."
    scrcpy -S -K -s "$DEVICE_ID" --stay-awake &
    sleep 1
}

#=============================
# 解锁手机屏幕
#=============================
unlock_phone() {
    echo "🔓 尝试解锁手机..."
    ~/sh/unlockphone.sh
}

#=============================
# 检查并调整动画速度
#=============================
optimize_animations() {
    echo "⚙️ 关闭系统动画..."
    adb_cmd shell settings put global window_animation_scale 0
    adb_cmd shell settings put global transition_animation_scale 0
    adb_cmd shell settings put global animator_duration_scale 0
}

#=============================
# 检查 scrcpy 状态
#=============================
check_scrcpy() {
    if pgrep -x "scrcpy" > /dev/null; then
        echo "✅ scrcpy 已启动"
        # optimize_animations
    else
        echo "♻️ scrcpy 未运行，尝试重启..."
        ~/sh/startscrcpy.sh
    fi
}

#=============================
# 检查后台服务
#=============================
check_service() {
    local service_name="com.violindangerous.awakening/.AwakeService"
    local status
    status=$(adb_cmd shell dumpsys activity services | grep "$service_name" || true)

    if [ -z "$status" ]; then
        echo "🧩 服务未运行，启动 MainActivity..."
        adb_cmd shell am start -n com.violindangerous.awakening/.MainActivity
        sleep 0.5
        adb_cmd shell input tap 600 1400
        sleep 2
        adb_cmd shell input keyevent 4
    else
        echo "✅ 服务已运行，无需操作。"
    fi
}

#=============================
# 主流程
#=============================
start_scrcpy
unlock_phone
# check_service
sleep 1
check_scrcpy

echo "🎯 所有任务完成。"
