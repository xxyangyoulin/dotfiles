#!/bin/bash

echo "📱 当前设备: $MYPHONE"

DEVICE_ID=${MYPHONE:-""}

# 封装 adb 命令
adb_cmd() {
    if [ -n "$DEVICE_ID" ]; then
        adb -s "$DEVICE_ID" "$@"
    else
        adb "$@"
    fi
}

# 检查屏幕是否锁定的函数
is_locked() {
    adb_cmd shell dumpsys window | grep -E 'mDreamingLockscreen=(true|false)' | grep -q 'mDreamingLockscreen=true'
    return $?
}

# 尝试解锁屏幕的函数
unlock_screen() {
    echo "🔓 正在尝试解锁屏幕..."
    
    # 强制点亮屏幕
    adb_cmd shell input keyevent 224
    adb_cmd shell input keyevent 4
    sleep 1

    # 上滑屏幕解锁
    adb_cmd shell input swipe 500 1500 500 500
    sleep 1

    # 输入密码
    adb_cmd shell input text 7000
    adb_cmd shell input keyevent 66  # 模拟回车键
    sleep 1
}

# 检查屏幕是否锁定
if is_locked; then
    echo "🔒 检测到屏幕已锁定，开始解锁..."

    # 尝试第一次解锁
    unlock_screen

    # 检查是否解锁成功
    if is_locked; then
        echo "⚠️ 第一次解锁失败，重试中..."
        unlock_screen

        if is_locked; then
            echo "❌ 第二次解锁失败，请检查设备状态。"
        else
            echo "✅ 屏幕已在第二次尝试中成功解锁。"
        fi
    else
        echo "✅ 屏幕已在第一次尝试中成功解锁。"
    fi
else
    echo "🟢 屏幕已解锁，无需操作。"
fi

echo "🏁 解锁流程完成。"
