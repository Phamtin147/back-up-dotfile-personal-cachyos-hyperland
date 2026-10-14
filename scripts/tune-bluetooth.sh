#!/usr/bin/env bash
# ==============================================================================
# Script tối ưu Bluetooth kết nối tức thì (< 1s) cho bàn phím BLE Stars80 & T2 Mac
# ==============================================================================
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo "Vui lòng chạy script với quyền sudo: sudo tune-bluetooth.sh"
   exit 1
fi

echo "==> 1. Cấu hình /etc/bluetooth/main.conf..."
# Tắt Experimental để tránh lỗi retry RAP profile (gây trễ 4-5s)
sed -i 's/^[# ]*Experimental[ ]*=.*/Experimental = false/' /etc/bluetooth/main.conf
if ! grep -q "^Experimental = false" /etc/bluetooth/main.conf; then
    sed -i '/\[General\]/a Experimental = false' /etc/bluetooth/main.conf
fi

# Đảm bảo FastConnectable bật
sed -i 's/^[# ]*FastConnectable[ ]*=.*/FastConnectable = true/' /etc/bluetooth/main.conf
if ! grep -q "^FastConnectable = true" /etc/bluetooth/main.conf; then
    sed -i '/\[General\]/a FastConnectable = true' /etc/bluetooth/main.conf
fi

# Tối ưu chu kỳ BLE Auto-connect (100% duty cycle, cửa sổ 30ms)
sed -i 's/^[# ]*ScanIntervalAutoConnect[ ]*=.*/ScanIntervalAutoConnect = 48/' /etc/bluetooth/main.conf
sed -i 's/^[# ]*ScanWindowAutoConnect[ ]*=.*/ScanWindowAutoConnect = 48/' /etc/bluetooth/main.conf
if ! grep -q "^ScanIntervalAutoConnect" /etc/bluetooth/main.conf; then
    sed -i '/\[LE\]/a ScanIntervalAutoConnect = 48\nScanWindowAutoConnect = 48' /etc/bluetooth/main.conf
fi

# Tối ưu latency và khoảng thời gian kết nối BLE
sed -i 's/^[# ]*MinConnectionInterval[ ]*=.*/MinConnectionInterval = 6/' /etc/bluetooth/main.conf
sed -i 's/^[# ]*MaxConnectionInterval[ ]*=.*/MaxConnectionInterval = 9/' /etc/bluetooth/main.conf
sed -i 's/^[# ]*ConnectionLatency[ ]*=.*/ConnectionLatency = 0/' /etc/bluetooth/main.conf
if ! grep -q "^MinConnectionInterval" /etc/bluetooth/main.conf; then
    sed -i '/\[LE\]/a MinConnectionInterval = 6\nMaxConnectionInterval = 9\nConnectionLatency = 0' /etc/bluetooth/main.conf
fi

echo "==> 2. Cấu hình /etc/bluetooth/input.conf..."
# Bật UserspaceHID=persist để giữ nguyên node bàn phím ảo, không bị destroy khi sleep
sed -i 's/^[# ]*UserspaceHID[ ]*=.*/UserspaceHID = persist/' /etc/bluetooth/input.conf
if ! grep -q "^UserspaceHID = persist" /etc/bluetooth/input.conf; then
    sed -i '/\[General\]/a UserspaceHID = persist' /etc/bluetooth/input.conf
fi

echo "==> 3. Tối ưu Power Management cho UART Bluetooth..."
# Giữ UART Broadcom luôn sẵn sàng, không bị sleep sâu gây trễ wake
for uart in /sys/bus/pci/devices/0000:00:1e.0/dw-apb-uart.*/power/control; do
    if [[ -f "$uart" ]]; then
        echo "on" > "$uart" 2>/dev/null || true
    fi
done

echo "==> 4. Khởi động lại dịch vụ bluetooth..."
systemctl restart bluetooth

echo "==> HOÀN TẤT! Bluetooth đã được tối ưu hóa chuẩn xác."
