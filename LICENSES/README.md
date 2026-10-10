# Licenses and attribution

KacperOS is a **branding and integration project**. Shipping a bootable image means redistributing other people's software. That software is **not** claimed as original KacperOS source.

## Original to KacperOS

- Name and branding “KacperOS Rhodium”
- Session, panel, Openbox, PCManFM, locale, and nodm **configuration** in `config/`
- Helper scripts in `scripts/`
- Documentation in `docs/` and the top-level README
- Wallpaper under `assets/wallpapers/` (project artwork)

## Third-party (must keep their licenses)

| Component | Typical license | Notes |
| --- | --- | --- |
| Debian GNU/Linux squeeze/sid | DFSG / per-package | Entire rootfs. Each package has its own copyright under `/usr/share/doc/*/copyright` **inside the image**. |
| Linux kernel `zImage` (2.6.27.46 HTC/XDAndroid) | GPL-2.0 | Downstream kernel. Source was not rebuilt here; binary is historical. Redistribution requires corresponding source availability for GPL components. |
| HaRET (`HARET-DEBIAN.EXE`) | historically GPL | Windows CE Linux bootloader (handhelds.org / XDAndroid era). |
| initrd.gz | mixed / GPL tools | Busybox, e2fsck, dosfsck, glue script mounting `debian.img`. |
| Openbox | GPL-2.0 | |
| LXPanel, PCManFM, LXTerminal, related LXDE bits | GPL-2.0 | |
| nodm | GPL-2.0 | |
| Wicd | GPL-2.0 | |
| GNU libc, coreutils, etc. | GPL/LGPL | via Debian |

Before a **public binary release**, unpack the image and collect `/usr/share/doc/*/copyright`, confirm HaRET and kernel source offers, and publish that offer next to the tarball. This repository currently vendors **historical binaries** (`boot/zImage`, `boot/initrd.gz`, `boot/HARET-DEBIAN.EXE`) because they are required to boot the device; that is redistribution, not authorship.

## What not to say

Do not describe Debian, the kernel, HaRET, or LXDE as “written for KacperOS”. Say: custom build / distribution based on those projects.
