#!/usr/bin/env bash

# 检查环境变量是否存在全局代理
proxy_env=$(env | grep -E '^(http_proxy|https_proxy|HTTP_PROXY|HTTPS_PROXY)=')

# 若使用 GNOME 或桌面环境可额外检查 gsettings 全局代理
gsettings_proxy=$(command -v gsettings >/dev/null 2>&1 && gsettings get org.gnome.system.proxy mode 2>/dev/null)

if [ -n "$proxy_env" ] || [[ "$gsettings_proxy" == "'manual'" ]]; then
    echo '{"text":"Proxy","class":"on"}'
else
    echo '{"text":"","class":"off"}'
fi

