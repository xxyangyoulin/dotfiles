#!/usr/bin/env bash

# Usage:
# stowAdd.sh <package_name> <file_or_dir1> [file_or_dir2 ...]
# Example:
# stowAdd.sh zsh ~/.zshrc ~/.zshenv
# stowAdd.sh waybar ~/.config/waybar ~/.config/waybar-extra

set -e

DOTFILES_DIR="$HOME/dotfiles"

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <package_name> <file_or_dir1> [file_or_dir2 ...]"
    exit 1
fi

pkgName="$1"
shift  # 剩下的都是文件或目录路径

pkgDir="$DOTFILES_DIR/$pkgName"

# 创建包目录
if [ ! -d "$pkgDir" ]; then
    mkdir -p "$pkgDir"
    echo "Created package directory: $pkgDir"
fi

for srcPath in "$@"; do
    # 转绝对路径
    if [[ "$srcPath" != /* ]]; then
        srcPath="$(pwd)/$srcPath"
    fi

    if [ ! -e "$srcPath" ]; then
        echo "Warning: $srcPath does not exist, skipping"
        continue
    fi

    # 构建相对路径（从 $HOME 开始）
    if [[ "$srcPath" == $HOME/* ]]; then
        relPath="${srcPath#$HOME/}"
    else
        # 非 home 下文件，保留 basename
        relPath="$(basename "$srcPath")"
    fi

    targetPath="$pkgDir/$relPath"
    targetDir="$(dirname "$targetPath")"

    if [ -e "$targetPath" ]; then
        echo "Warning: Target $targetPath already exists in package, skipping"
        continue
    fi

    mkdir -p "$targetDir"

    mv "$srcPath" "$targetPath"
    echo "Moved $srcPath -> $targetPath"
done

# 执行 stow
cd "$DOTFILES_DIR"
stow "$pkgName"

echo "Stowed package $pkgName successfully"

