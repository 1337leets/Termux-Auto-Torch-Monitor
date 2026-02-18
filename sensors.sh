#!/data/data/com.termux/files/usr/bin/bash

SENSOR_NAME="tsl2591 Ambient Light Sensor Non-wakeup"

get_lux() {
    termux-sensor -s "$SENSOR_NAME" -n 1 2>/dev/null \
    | jq -r '.[].values[0] // 0'
}
