# SmoothDisplayTile — Build Instructions

## Requirements
- Android Studio (any recent version) OR
- Android SDK command line tools with Java 11+

## Build via Android Studio
1. Open this folder as a project in Android Studio
2. Let Gradle sync
3. Build → Generate Signed Bundle/APK → APK → use debug key (or your own)
4. Output: `app/build/outputs/apk/release/app-release.apk`
5. Rename to `SmoothDisplayTile.apk`

## Build via command line
```bash
# Make sure ANDROID_HOME is set to your SDK path
./gradlew assembleRelease
# APK at: app/build/outputs/apk/release/app-release-unsigned.apk
# Sign it with apksigner (included in Android SDK build-tools)
```

## After building
- Option A: Place `SmoothDisplayTile.apk` inside the module ZIP (alongside module.prop).
  customize.sh will auto-install it during flash.
- Option B: Sideload manually via `adb install SmoothDisplayTile.apk` or any file manager.

## Adding the tile
After install, pull down Quick Settings → Edit tiles → drag "Smooth Display Toggle" into your panel.

## How it works
- The APK registers an Android TileService (`android.service.quicksettings.action.QS_TILE`)
- When tapped, it runs `su -c sh /data/adb/modules/SmoothDisplayToggle/tile.sh` as root
- tile.sh cycles the mode and applies the refresh rate settings live
- The tile label updates to show current mode (Auto / 60Hz / 90Hz)
