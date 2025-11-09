#!/bin/bash
# ~/.local/bin/waybar-cn-clock
# 输出格式：月/日 周一 12:31:12

month=$(date +%m)
day=$(date +%d)
time=$(date +%H:%M:%S)
w=$(date +%u)  # 1..7

map=(一 二 三 四 五 六 日)

echo "${month}/${day} ${time}"

