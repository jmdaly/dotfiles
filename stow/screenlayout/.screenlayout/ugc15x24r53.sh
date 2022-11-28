#!/bin/sh
xrandr \
  --output DP-0 --primary --mode 1680x1050 --pos 0x795 --rotate normal \
  --output DP-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output DP-4 --mode 1920x1200 --pos 3600x0 --rotate left \
  --output DP-5 --off \
  --output DP-6 --mode 1920x1200 --pos 1680x720 --rotate normal \
  --output DP-7 --off
