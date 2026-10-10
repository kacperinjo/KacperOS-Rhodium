# Sprzęt — HTC Touch Pro2 (Rhodium RHOD100)

| | |
| --- | --- |
| Codename | Rhodium |
| Model | RHOD100 (GSM) |
| SoC | Qualcomm MSM7201A (ARM11) |
| Panel | 480×800; w Xorg obrót `CW` → **800×480** landscape |
| Wejście | rezystancyjny dotyk, fizyczna QWERTY (wysuwana) |
| Sieć | Wi-Fi wl1251 (MAC w cmdline HaRET) |
| Nośnik | microSD; rootfs jako plik loop na FAT32 |

## Kernel

Stabilny, ten z `boot/zImage`:

```
Linux version 2.6.27.46-01162-g741ab49
PREEMPT Mon Aug 30 12:39:35 CEST 2010
gcc 4.3.2 (Sourcery G++ Lite 2008q3-72)
```

Downstream HTC Linux / XDAndroid, ARMv6. Nie wymieniaj go na losowy zImage. Ten kernel obsługuje framebuffer, dotyk, QWERTY, SD i Wi-Fi wl1251.

Eksperyment na **osobnym** branchu/teście: 2.6.35 z dawnych portów HTC Linux. Nie mieszać ze stabilnym bootem.

Moduły historyczne (XDAndroid): `modules-2.6.27.46-01356-gd4c73bd.tar.gz`.

## Initrd

Historyczny initrd (gzip `INITRD`, 2010):

1. czeka na `mmcblk0`
2. montuje FAT32 jako `/sdcard`
3. `losetup /dev/block/loop2 /sdcard/debian.img`
4. `e2fsck -y`
5. mount ext2 rw (`sync`) na `/rfs`
6. `switch_root /rfs /init`

## HaRET

Windows CE bootloader. Uruchamiany z karty jako `HARET-DEBIAN.EXE`. Parametry w `startup.txt`.
