#!/usr/bin/env bash
# Hyprland 智能窗口切换脚本
# 用法: hyprtogglewindow.sh "<启动命令>" "<window_class>" "<可选:隐藏其他class,用逗号分隔>"

launch_cmd="$1"
win_class="$2"
hidden_other_classes="$3"

if [[ -z "$launch_cmd" || -z "$win_class" ]]; then
    echo "Usage: $0 <launch_cmd> <window_class> [hidden_other_classes]"
    exit 1
fi

# 获取当前活跃窗口及工作区信息 (使用 -j 格式更稳定)
active_info=$(hyprctl activewindow -j)
active_address=$(echo "$active_info" | jq -r '.address')
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# 获取目标窗口信息
target_window=$(hyprctl clients -j | jq -r --arg cls "$win_class" '.[] | select(.class == $cls) | "\(.workspace.id) \(.address)"' | head -n1)

# 如果窗口不存在，则启动程序
if [ -z "$target_window" ]; then
    echo "程序未运行，启动中..."
    setsid $launch_cmd >/dev/null 2>&1 &
    exit 0
fi

read ws_id win_address <<< "$target_window"

if [ "$ws_id" -ne "$current_ws" ]; then
    # 窗口在其他 workspace → 移动到当前 workspace 并聚焦
    echo "窗口在其他 workspace，移动到当前 workspace..."
    hyprctl --batch "dispatch movetoworkspacesilent $current_ws,address:$win_address ; dispatch focuswindow address:$win_address ; dispatch bringactivetotop"
else
    # 窗口在当前 workspace
    if [ "$win_address" = "$active_address" ]; then
        echo "窗口已聚焦，准备隐藏..."
        
        # 【核心逻辑修改】获取同工作区、非当前的、上一个聚焦窗口的地址
        last_win=$(hyprctl clients -j | jq -r --arg ws "$current_ws" --arg addr "$win_address" \
            '[.[] | select(.workspace.id == ($ws|tonumber) and .address != $addr)] 
            | sort_by(.focusHistoryID) 
            | .[0].address')
        
        if [ "$last_win" != "null" ] && [ -n "$last_win" ]; then
            echo "找到同工作区上一个窗口 $last_win，执行无缝切换..."
            # 使用 --batch：先切换焦点到旧窗口，再把当前窗口扔进 special
            # 这样 Hyprland 引擎就不会因为“焦点真空”而自动乱跳到最近的平铺窗口
            hyprctl --batch "dispatch focuswindow address:$last_win ; dispatch movetoworkspacesilent special,address:$win_address"
        else
            echo "同工作区没有其他窗口，直接隐藏..."
            hyprctl dispatch movetoworkspacesilent "special,address:$win_address"
        fi
    else
        echo "窗口未聚焦，聚焦并置顶..."
        hyprctl dispatch focuswindow "address:$win_address"
        hyprctl dispatch bringactivetotop
    fi
fi

# 隐藏指定的其他 floating 窗口
if [[ -n "$hidden_other_classes" ]]; then
    IFS=',' read -ra classArray <<< "$hidden_other_classes"
    for cls in "${classArray[@]}"; do
        # 只隐藏当前工作区的特定 floating 窗口，避免误伤其他桌面的窗口
        floating_windows=$(hyprctl clients -j | jq -r --arg cls "$cls" --arg ws "$current_ws" \
            '.[] | select(.class == $cls and .floating == true and .workspace.id == ($ws|tonumber)) | .address')
        for addr in $floating_windows; do
            echo "隐藏 floating 窗口 $cls ($addr) 到 special workspace..."
            hyprctl dispatch movetoworkspacesilent "special,address:$addr"
        done
    done
fi