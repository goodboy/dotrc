#!/bin/sh
xrandr --output eDP-1 \
    --primary \
    --mode 3200x1800 \
    --pos 3840x360 \
    --rotate normal \
    --output DP-1 \
    --mode 3840x2160 \
    --pos 0x0 \
    --rotate normal \
    --output HDMI-1 \
    --off
