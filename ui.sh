render_status() {
    local time="$1"
    local lux="$2"
    local temp="$3"
    local volt="$4"
    local batt="$5"
    local state="$6"

    icon="🌙"
    [ "$state" = "on" ] && icon="🔥"

    printf "\r%s | Lux:%s %s | Temp:%.1f°C | Volt:%.2fV | Batt:%s%%" \
        "$time" "$lux" "$icon" "$temp" "$volt" "$batt"
}
