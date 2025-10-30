#!/bin/bash

# network_traffic_total.sh [POLLING_INTERVAL]

isecs=${1:-1}

snore() {
    local IFS
    [[ -n "${_snore_fd:-}" ]] || { exec {_snore_fd}<> <(:); } 2>/dev/null
    read ${1:+-t "$1"} -u $_snore_fd || :
}

human_readable() {
  local value=$1
  local units=( B K M G T P )
  local index=0
  while (( value > 1000 && index < 5 )); do
        (( value /= 1000, index++ ))
  done
  echo "$value${units[$index]}"
}

# 获取所有有效网卡
get_interfaces() {
    ls /sys/class/net | grep -E '^(eth|enp|wlan|wlp)'
}

# sanity check
interfaces=( $(get_interfaces) )
if [ ${#interfaces[@]} -eq 0 ]; then
    printf '{"text": "No valid iface"}\n'
    exit 1
fi
test "$isecs" -gt 0 || { printf '{"text": "%s"}\n' "${isecs} not valid"; exit 1; }

declare -a traffic_prev traffic_curr traffic_delta
traffic_prev=( 0 0 )

while snore ${isecs} ; do
    total_rx=0
    total_tx=0
    for iface in "${interfaces[@]}"; do
        read rx tx < <(awk '/^ *'${iface}':/{print $2 " " $10}' /proc/net/dev)
        (( total_rx += rx ))
        (( total_tx += tx ))
    done

    if [ -n "${traffic_prev[0]}" ]; then
        delta_rx=$(( (total_rx - traffic_prev[0]) / isecs ))
        delta_tx=$(( (total_tx - traffic_prev[1]) / isecs ))
    else
        delta_rx=0
        delta_tx=0
    fi

    traffic_prev=( $total_rx $total_tx )

    printf '{"text": "%5s⇣ %5s⇡"}\n' $(human_readable $delta_rx) $(human_readable $delta_tx)
done

