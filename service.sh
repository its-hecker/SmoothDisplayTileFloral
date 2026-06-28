#!/system/bin/sh

MODDIR=${0%/*}
MODE_CONF="/data/adb/smoothdisplay/mode.conf"

# Wait for boot to complete
until [ "$(getprop sys.boot_completed)" = "1" ]; do
  sleep 2
done
sleep 3

apply_mode() {
  local mode="$1"
  case "$mode" in
    90hz)
      settings put system peak_refresh_rate 90
      settings put system min_refresh_rate 90
      device_config put display_manager peak_refresh_rate 90
      device_config put display_manager min_refresh_rate 90
      settings put global battery_saver_constants \
        "vibration_disabled=false,animation_disabled=false,soundtrigger_disabled=false,\
firewall_disabled=false,adjust_brightness_disabled=true,adjust_brightness_factor=0.5,\
fullbackup_deferred=false,keyvaluebackup_deferred=false,force_all_apps_standby=false,\
force_background_freeze=false,optional_sensors_disabled=true,aod_disabled=false,\
activate_datasaver=false"
      settings put global low_power_refresh_rate 90 2>/dev/null || true
      ;;
    60hz)
      settings put system peak_refresh_rate 60
      settings put system min_refresh_rate 60
      device_config put display_manager peak_refresh_rate 60
      device_config put display_manager min_refresh_rate 60
      settings delete global battery_saver_constants 2>/dev/null || true
      settings delete global low_power_refresh_rate 2>/dev/null || true
      ;;
    auto|*)
      settings delete system peak_refresh_rate
      settings delete system min_refresh_rate
      device_config delete display_manager peak_refresh_rate
      device_config delete display_manager min_refresh_rate
      settings delete global battery_saver_constants 2>/dev/null || true
      settings delete global low_power_refresh_rate 2>/dev/null || true
      ;;
  esac
}

mkdir -p /data/adb/smoothdisplay
[ ! -f "$MODE_CONF" ] && echo "auto" > "$MODE_CONF"

MODE=$(cat "$MODE_CONF" | tr -d '[:space:]')
apply_mode "$MODE"
LAST_MODE="$MODE"

while true; do
  sleep 5
  CURRENT_MODE=$(cat "$MODE_CONF" 2>/dev/null | tr -d '[:space:]')
  [ -z "$CURRENT_MODE" ] && CURRENT_MODE="auto"
  if [ "$CURRENT_MODE" != "$LAST_MODE" ]; then
    apply_mode "$CURRENT_MODE"
    LAST_MODE="$CURRENT_MODE"
  fi
done
