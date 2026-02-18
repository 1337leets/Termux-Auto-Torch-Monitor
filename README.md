# Termux-Auto-Torch-Monitor

Ambient light sensor–driven automatic torch control with real-time battery temperature and voltage monitoring.

A lightweight, modular shell-based control system built for Termux.  
Uses Android sensor APIs via Termux-API to implement automatic flashlight control based on ambient light intensity, while displaying live battery diagnostics in a real-time terminal panel.

---

## ✨ Features

- Ambient light sensor–based automatic torch control
- Configurable low/high lux hysteresis thresholds
- Real-time battery monitoring:
  - Temperature
  - Voltage
  - Percentage
- Deterministic 1 Hz control loop
- Temporary manual torch pulse (`t` key)
- Clean exit with `q`
- Modular architecture (separated sensor, battery, torch, UI layers)

---

## 🧠 Architecture

The project follows a modular separation-of-concerns design:
- main.sh      → event loop & orchestration 
- sensors.sh   → ambient light sensor interface 
- battery.sh   → battery diagnostics 
- torch.sh     → torch control logic 
- ui.sh        → terminal rendering

The control loop operates at a fixed interval to minimize timing drift and ensure stable output.

Torch logic uses hysteresis thresholds:

- Turn ON when `lux < LOW`
- Turn OFF when `lux > HIGH`

---

## 📦 Requirements

- Termux
- Termux-API
- jq

Install dependencies:

```bash
pkg install jq
pkg install termux-api
```
Make sure the Termux:API app is installed from F-Droid or Play Store.

## 🚀 Usage

Clone the repository:
```bash
git clone https://github.com/1337leets/Termux-Auto-Torch-Monitor.git
cd Termux-Auto-Torch-Monitor
chmod +x *.sh
./main.sh
```

## Controls:

* q → quit safely
* t → temporary torch pulse (manual override)

## ⚙️ Configuration

Edit thresholds in main.sh:
```bash
LOW=5
HIGH=10
```
Values depend on your device’s ambient light sensor characteristics.

## ⚠️ Notes

* Sensor names vary across devices.
* The script currently expects a TSL2591-based ALS.
* Modify sensors.sh if your device exposes a different sensor identifier.
* Frequent torch usage may increase device temperature and battery drain.
