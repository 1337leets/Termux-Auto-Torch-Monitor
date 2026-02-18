#!/data/data/com.termux/files/usr/bin/bash

TORCH_STATE="off"

torch_on() {
    termux-torch on
    TORCH_STATE="on"
}

torch_off() {
    termux-torch off
    TORCH_STATE="off"
}

torch_toggle_by_lux() {
    local lux="$1"
    local low="$2"
    local high="$3"

    if [ "$lux" -lt "$low" ] && [ "$TORCH_STATE" != "on" ]; then
        torch_on
    elif [ "$lux" -gt "$high" ] && [ "$TORCH_STATE" != "off" ]; then
        torch_off
    fi
}
