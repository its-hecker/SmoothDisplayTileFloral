# Smooth Display Toggle for Floral
**by Hecker** | [t.me/pixel4seriesupdates](https://t.me/pixel4seriesupdates)

A KernelSU module to control display refresh rate on Pixel 4 / 4XL.

## Features
- Force 90Hz, Force 60Hz, or Auto (Smooth Display)
- WebUI accessible from KernelSU manager
- Quick Settings tile companion app (bundled, auto-installs on flash)
- Persists across reboots
- Supports Pixel 4 (flame) and Pixel 4 XL (coral)

## Requirements
- Pixel 4 (flame) or Pixel 4 XL (coral)
- KernelSU, ReSukiSU, or any other root manager
- Kirisakura kernel (or any kernel with 90Hz support)

## Install
1. Download the ZIP from [Releases](../../releases)
2. Flash via KernelSU
3. Reboot
4. Add "Smooth Display Toggle" tile to Quick Settings
5. Approve root access in ReSukiSU/Ksu. Use QS tiles to set refresh rate
6. Use KernelSU WebUI to control mode & show refresh rate

## Structure
- `app/` — QS tile companion app source (Android Studio)
- `module/` — KernelSU module scripts and WebUI

## Notes
- WebUI and QS tile work independently
- First tile tap requires root grant approval, automatic after that
