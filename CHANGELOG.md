# Changelog

## 0.1.2 — 2026-10-10

Boot-tested on HTC Touch Pro2 RHOD100. This is the image published with the HaRET boot files.

- Wicd unescapes wireless-tools `\xHH` SSIDs, so a network name with Polish letters is the name that gets joined. The daemon locale is `pl_PL.UTF-8`.
- Keyboard backlight is a loop in `/etc/kacperos-kbd-light` (`klt::keypad-bkl`, `brightness2`), started from `rc.local` without aborting if the boot sound fails.
- Openbox vertically maximizes application windows. PCManFM and Wicd default heights sit above the 48 px panel.

## 0.1.1 — 2026-10-10

- Wallpaper: pcmanfm 0.9.7 reads `~/.config/pcmanfm/pcmanfm.conf` with numeric `wallpaper_mode=1`.
- Panel icons 40 px, taskbar no longer stretches them across the bar.
- Wi-Fi templates force WPA2-CCMP. Mixed TKIP made wl1251 report a bad password.
- Keyboard backlight turns on from `rc.local` (`klt::keypad-bkl`).

## 0.1.0 — 2026-10-10

- Repository layout, scripts, and documentation.
- Confirm work-image session: Openbox + LXPanel + PCManFM, nodm, 1 desktop.
- Wallpaper KacperOS Rhodium scaled to 800×480 JPEG.
- `.xsession` starts desktop + panel only (no extra PCManFM windows).
- Disable sphone XDG autostart.
- `pl_PL.UTF-8` already generated in the work image locale-archive; keep LANG files in sync.
