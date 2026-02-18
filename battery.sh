#!/data/data/com.termux/files/usr/bin/bash

get_battery_json() {
    termux-battery-status 2>/dev/null
}

get_battery_percentage() {
    echo "$1" | jq -r '.percentage // 0'
}

get_battery_temp() {
    echo "$1" | jq -r '.temperature // 0'
}

get_battery_voltage() {
    mv=$(echo "$1" | jq -r '.voltage // 0')
    awk -v mv="$mv" 'BEGIN {printf "%.2f", mv/1000}'
}
