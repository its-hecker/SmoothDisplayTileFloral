#!/system/bin/sh
SKIPUNZIP=1

ui_print ""
ui_print "========================================"
ui_print "   Smooth Display Toggle for Floral"
ui_print "   by Hecker  -  v1.6"
ui_print "========================================"
ui_print ""

DEVICE=$(getprop ro.product.device)
if [ "$DEVICE" != "coral" ] && [ "$DEVICE" != "flame" ]; then
  ui_print "[!] Unsupported device: $DEVICE"
  ui_print "[!] Supports coral (Pixel 4 XL) and flame (Pixel 4) only."
  abort
fi
ui_print "[*] Device: $DEVICE - OK"
ui_print ""
ui_print "[*] Extracting module files..."

for f in module.prop post-fs-data.sh service.sh tile.sh action.sh uninstall.sh; do
  unzip -o "$ZIPFILE" "$f" -d "$MODPATH" >/dev/null 2>&1
done
unzip -o "$ZIPFILE" 'webroot/*' -d "$MODPATH" >/dev/null 2>&1

set_perm_recursive "$MODPATH" root root 0755 0644
chmod 0755 "$MODPATH/post-fs-data.sh"
chmod 0755 "$MODPATH/service.sh"
chmod 0755 "$MODPATH/tile.sh"
chmod 0755 "$MODPATH/action.sh"
chmod 0755 "$MODPATH/uninstall.sh"

mkdir -p /data/adb/smoothdisplay
chmod 0755 /data/adb/smoothdisplay

if [ ! -f /data/adb/smoothdisplay/mode.conf ]; then
  echo "auto" > /data/adb/smoothdisplay/mode.conf
fi

# Install companion QS tile APK
APK_PATH="$MODPATH/SmoothDisplayTile.apk"
unzip -o "$ZIPFILE" "SmoothDisplayTile.apk" -d "$MODPATH" >/dev/null 2>&1
if [ -f "$APK_PATH" ]; then
  ui_print "[*] Installing QS tile companion app..."
  pm install -r "$APK_PATH" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    ui_print "[+] QS tile app installed!"
    ui_print ""
    ui_print "[!] IMPORTANT — After reboot:"
    ui_print "[!] 1. Pull down QS panel, tap pencil (edit)"
    ui_print "[!] 2. Find 'Smooth Display Toggle' and drag it in"
    ui_print "[!]    (or run: adb shell cmd statusbar add-tile"
    ui_print "[!]     com.hecker.smoothdisplaytile/.RefreshRateTileService)"
    ui_print "[!] 3. Tap the tile ONCE — approve root access in"
    ui_print "[!]    the ReSukiSU prompt that appears"
    ui_print "[!] Root is needed to read/write the mode config."
  else
    ui_print "[!] Auto-install failed — install SmoothDisplayTile.apk manually."
    ui_print "[!] Get it from t.me/pixel4seriesupdates"
  fi
else
  ui_print "[!] SmoothDisplayTile.apk not found in ZIP."
fi

ui_print ""
ui_print "[*] Default mode: auto (Smooth Display)"
ui_print "[+] Installation complete! Reboot to activate."
ui_print "[+] Open KernelSU WebUI to control refresh rate."
ui_print "========================================"
