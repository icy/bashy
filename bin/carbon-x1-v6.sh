#!/usr/bin/env bash

# Purpose : Booting up ThinkPad Carbon X1-v6
# Author  : Mr. Internet
# Date    : 2019-09-02

set -x

# Disabling the memory card reader
echo "2-3" | sudo tee /sys/bus/usb/drivers/usb/unbind || true

# Why? Who cares; it just works.
echo N | sudo tee /sys/module/overlay/parameters/metacopy
