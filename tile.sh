#!/system/bin/sh
# Called by KernelSU when the QS tile is tapped.
# Cycles: auto -> 60hz -> 90hz -> auto -> ...

CONF="/data/adb/smoothdisplay/mode.conf"
MODE="auto"
[ -f "$CONF" ] && MODE=$(cat "$CONF" | tr -d '[:space:]')

# Advance to next mode
case "$MODE" in
  auto)  NEXT="60hz" ;;
  60hz)  NEXT="90hz" ;;
  90hz)  NEXT="auto" ;;
  *)     NEXT="auto" ;;
esac

echo "$NEXT" > "$CONF"

# Apply live
case "$NEXT" in
  90hz)
    settings put system peak_refresh_rate 90
    settings put system min_refresh_rate 90
    device_config put display_manager peak_refresh_rate 90
    device_config put display_manager min_refresh_rate 90
    settings put global battery_saver_constants \
      "vibration_disabled=false,animation_disabled=false,soundtrigger_disabled=false,firewall_disabled=false,adjust_brightness_disabled=true,adjust_brightness_factor=0.5,fullbackup_deferred=false,keyvaluebackup_deferred=false,force_all_apps_standby=false,force_background_freeze=false,optional_sensors_disabled=true,aod_disabled=false,activate_datasaver=false"
    ;;
  60hz)
    settings put system peak_refresh_rate 60
    settings put system min_refresh_rate 60
    device_config put display_manager peak_refresh_rate 60
    device_config put display_manager min_refresh_rate 60
    settings delete global battery_saver_constants 2>/dev/null
    ;;
  auto)
    settings delete system peak_refresh_rate
    settings delete system min_refresh_rate
    device_config delete display_manager peak_refresh_rate
    device_config delete display_manager min_refresh_rate
    settings delete global battery_saver_constants 2>/dev/null
    ;;
esac

# Return label for tile subtitle
case "$NEXT" in
  90hz) echo "90Hz — Forced" ;;
  60hz) echo "60Hz — Forced" ;;
  auto) echo "Auto (Smooth Display)" ;;
esac
