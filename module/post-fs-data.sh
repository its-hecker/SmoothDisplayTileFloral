#!/system/bin/sh

MODDIR=${0%/*}
MODE_CONF="/data/adb/smoothdisplay/mode.conf"

# Read saved mode, default to auto
MODE="auto"
if [ -f "$MODE_CONF" ]; then
  MODE=$(cat "$MODE_CONF" | tr -d '[:space:]')
fi

case "$MODE" in
  90hz)
    resetprop persist.sys.refresh_rate.override 90
    ;;
  60hz)
    resetprop persist.sys.refresh_rate.override 60
    ;;
  auto|*)
    # Remove override so Android manages refresh rate naturally
    resetprop --delete persist.sys.refresh_rate.override 2>/dev/null
    ;;
esac
