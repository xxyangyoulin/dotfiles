#!/bin/bash

# 检查是否传入了包名
if [ -z "$1" ]; then
    echo "请提供要安装的包名。"
    exit 1
fi

# 设置工作目录
CACHE_DIR="/home/yyl/.cache/yay"
PKG_NAME="$1"
REPO_URL="git@github.com:archlinux/aur.git"
PKG_DIR="$CACHE_DIR/$PKG_NAME"

# 检查是否已存在克隆的目录
if [ -d "$PKG_DIR" ]; then
    echo "$PKG_NAME 仓库已经存在。"
    read -p "是否使用当前仓库（y/n）? " choice
    case "$choice" in
        y|Y)
            echo "使用现有仓库 $PKG_NAME"
            cd "$PKG_DIR" || exit 1
            ;;
        n|N)
            echo "重新克隆 $PKG_NAME"
            rm -rf "$PKG_DIR"  # 删除现有目录
            git clone --single-branch -b "$PKG_NAME" "$REPO_URL" "$PKG_DIR"
            cd "$PKG_DIR" || exit 1
            ;;
        *)
            echo "无效选择，退出。"
            exit 1
            ;;
    esac
else
    # 如果目录不存在，则进行克隆
    echo "正在克隆 $PKG_NAME..."
    git clone --single-branch -b "$PKG_NAME" "$REPO_URL" "$PKG_DIR"
    cd "$PKG_DIR" || exit 1
fi

# 使用 makepkg 构建并安装
echo "正在构建并安装 $PKG_NAME..."
makepkg -si

