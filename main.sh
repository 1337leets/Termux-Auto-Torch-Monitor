#!/data/data/com.termux/files/usr/bin/bash

# main.sh - Orkestratör
# Beklenen: sensors.sh, battery.sh, torch.sh, ui.sh aynı dizinde ve executable/fonksiyon içeriyor.

set -u
shopt -s expand_aliases

# Modülleri yükle
source ./sensors.sh
source ./battery.sh
source ./torch.sh
source ./ui.sh

# Ayarlar
LOW=5
HIGH=10
INTERVAL=1        # saniye cinsinden sabit periyot
KEY_POLL=0.1      # her döngüde klavye kontrolü için timeout (saniye)

cleanup() {
    # Güvenli temizleme
    termux-torch off 2>/dev/null || true
    tput cnorm 2>/dev/null || true
    stty sane 2>/dev/null || true
    echo
    exit 0
}

trap cleanup INT TERM EXIT

# Terminali gerçek-zamanlı girdi okumaya hazırla
stty -echo -icanon time 0 min 0 2>/dev/null || true
tput civis 2>/dev/null || true

# Main loop (deterministic periyot)
while true; do
    START=$(date +%s)

    TIME=$(date +"%H:%M:%S")

    # Sensör okuma
    LUX=$(get_lux 2>/dev/null || echo 0)
    LUX_INT=$(printf "%.0f" "$LUX" 2>/dev/null || echo 0)

    # Torch kontrolü (otomatik)
    torch_toggle_by_lux "$LUX_INT" "$LOW" "$HIGH"

    # Batarya bilgisi
    BJSON=$(get_battery_json 2>/dev/null || echo "{}")
    TEMP=$(get_battery_temp "$BJSON" 2>/dev/null || echo 0)
    BATT=$(get_battery_percentage "$BJSON" 2>/dev/null || echo 0)
    VOLT=$(get_battery_voltage "$BJSON" 2>/dev/null || echo 0)

    # Ekrana yaz
    render_status "$TIME" "$LUX_INT" "$TEMP" "$VOLT" "$BATT" "$TORCH_STATE"

    # Kısa süreli non-blocking input kontrolü
    read -t "$KEY_POLL" -n 1 KEY 2>/dev/null || KEY=""
    if [[ "$KEY" == "q" ]]; then
        cleanup
    elif [[ "$KEY" == "t" ]]; then
        # Manuel toggle (opsiyonel; torch.sh içinde torch_toggle_manual varsa çağır)
        if type torch_toggle_manual >/dev/null 2>&1; then
            torch_toggle_manual
        else
            # fallback: elle toggle
            if [[ "$TORCH_STATE" == "on" ]]; then
                termux-torch off && TORCH_STATE="off"
            else
                termux-torch on && TORCH_STATE="on"
            fi
        fi
    fi

    # Periyot hesapla ve kalan zamanı uyu
    END=$(date +%s)
    ELAPSED=$((END - START))
    SLEEP_TIME=$((INTERVAL - ELAPSED))
    if [ "$SLEEP_TIME" -gt 0 ]; then
        sleep "$SLEEP_TIME"
    fi
done
