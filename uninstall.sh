#!/system/bin/sh
resetprop --delete persist.sys.refresh_rate.override 2>/dev/null
settings delete system peak_refresh_rate
settings delete system min_refresh_rate
device_config delete display_manager peak_refresh_rate
device_config delete display_manager min_refresh_rate
settings delete global battery_saver_constants 2>/dev/null
settings delete global low_power_refresh_rate 2>/dev/null
rm -rf /data/adb/smoothdisplay
