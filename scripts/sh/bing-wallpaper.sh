#!/bin/bash

# 设置保存路径
SAVE_DIR="$HOME/Pictures/wallpapers"
mkdir -p "$SAVE_DIR"

# 获取当天日期，格式为 yyyy-mm-dd
TODAY=$(date +%F)

# 获取 Bing API 返回的壁纸数据
BING_API_URL="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&uhd=1&uhdwidth=3840&uhdheight=2160"
BING_JSON=$(curl -s "$BING_API_URL")

# 提取壁纸的 URL
IMAGE_URL="https://www.bing.com$(echo "$BING_JSON" | jq -r '.images[0].url')"

# 从 URL 中提取文件名（去掉查询参数部分）
IMAGE_NAME=$(basename "$IMAGE_URL" | cut -d'?' -f1)

# 设置保存的文件名为 bing_日期.扩展名
IMAGE_PATH="$SAVE_DIR/bing_${TODAY}_$IMAGE_NAME"

# 如果壁纸已经存在，则跳过下载
if [ -f "$IMAGE_PATH" ]; then
    echo "壁纸已存在，无需下载。"
else
    echo "壁纸有变化，正在下载新壁纸..."
    # 下载新壁纸
    curl -o "$IMAGE_PATH" "$IMAGE_URL"
    echo "新壁纸已下载: $IMAGE_PATH"
fi

# 设置壁纸变量
wallpaper="$IMAGE_PATH"

# 如果 hyprpaper 已加载，卸载所有壁纸，再重新加载并设置
if hyprctl hyprpaper unload all; then
    hyprctl hyprpaper preload "$wallpaper"
    hyprctl hyprpaper wallpaper ",${wallpaper}"
    echo "壁纸已设置：$wallpaper"
else
    echo "Hyprpaper 加载失败，无法更换壁纸。"
fi

