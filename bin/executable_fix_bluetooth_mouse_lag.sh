#!/bin/bash
HANDLE="$(hcitool con | grep 'DA:95:49:7A:A1:F7' | awk '{print $5}')"  # get the device handle
sudo hcitool lecup --handle $HANDLE --latency 0 --min 6 --max 8
exit 0
