#!/bin/sh
# uncomment for debug mode
# set -x

xrandr \
    --output eDP-1 \
    --primary \
    --mode 3200x1800 \
    --pos 0x1728 \
    --rotate normal \
    --output HDMI-1 \
    --scale 1.6x1.6 \
    --mode 1920x1080 \
    --pos 0x0 \
    --rotate normal
    --output DP-1 --off \
