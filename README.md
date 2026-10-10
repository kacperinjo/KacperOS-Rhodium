# KacperOS Rhodium

KacperOS Rhodium to gotowy Linux na HTC Touch Pro2 (Rhodium **RHOD100**). Nie jest pisany od zera: userspace to Debian GNU/Linux Squeeze (ARM), kernel to historyczny obraz HTC Linux / XDAndroid, a z Windows Mobile startuje go **HaRET**.

**KacperOS Rhodium is a ready-to-boot Linux build for the HTC Touch Pro2 (Rhodium RHOD100).** It is not a from-scratch OS. The userspace is Debian GNU/Linux Squeeze (ARM). The kernel is a historical HTC Linux / XDAndroid image. HaRET loads that kernel from Windows Mobile.

Branding, układ sesji, skrypty i tapeta są z tego projektu. Debian, kernel, HaRET, Openbox, LXPanel, PCManFM i reszta programów zostają dziełem swoich autorów. Szczegóły: [LICENSES/README.md](LICENSES/README.md).

| | |
| --- | --- |
| Urządzenie / device | HTC Touch Pro2, Rhodium **RHOD100** (GSM) |
| SoC | Qualcomm MSM7201A (ARM11 / ARMv6) |
| Ekran / screen | panel 480×800, pulpit **800×480** landscape (`fbdev` Rotate CW) |
| Kernel | Linux **2.6.27.46-01162-g741ab49** PREEMPT, zbudowany 30.08.2010 (GCC 4.3.2 Sourcery G++ Lite 2008q3-72). Nie podmieniaj go na nowszy. |
| Bootloader | **HaRET** (`boot/HARET-DEBIAN.EXE`), start z Windows Mobile |
| Initrd | historyczny gzip z 16.09.2010: FAT32 → loop `/sdcard/debian.img` → `switch_root` |
| Rootfs | jeden plik `debian.img` (ext2, 2 000 000 000 bajtów) w katalogu głównym karty FAT32 |
| Pulpit / desktop | Openbox + LXPanel + PCManFM, autologowanie przez nodm jako `user` |
| Locale | `pl_PL.UTF-8` |
| Wi-Fi | Texas Instruments wl1251, interfejs `eth0`, sterownik `wext`, tylko **WPA2-PSK (CCMP/AES)** |
| Wersja / version | [`VERSION`](VERSION) — **0.1.3**. Obraz 0.1.2 był sprawdzony na telefonie 10.10.2026; 0.1.3 dodaje `sudo` bez hasła. |

## Gotowiec

Pliki startowe są w tym repozytorium, w `boot/`. Obraz systemu ma ~1,9 GB i jest za duży na zwykły Git, więc leży przy wydaniu **0.1.3** jako `debian.img`.

1. Karta microSD, system plików **FAT32**.
2. Na **katalog główny** karty skopiuj:
   - `HARET-DEBIAN.EXE`, `startup.txt`, `default.txt`, `zImage`, `initrd.gz` z `boot/` (albo z wydania)
   - `debian.img` z [wydania 0.1.3](https://github.com/kacperinjo/KacperOS-Rhodium/releases/tag/v0.1.3)
3. W Windows Mobile uruchom z karty `HARET-DEBIAN.EXE`.

Nazwa obrazu musi zostać `debian.img`. Initrd szuka `/sdcard/debian.img` i nie zagląda do podkatalogów.

`startup.txt` w tym wydaniu ma adres Wi-Fi i kalibrację dotyku z jednego egzemplarza RHOD100 (`wl1251_mac=00:1f:df:b1:23:30`, `msmts_calib=0x9f.0x39a.0x35c.0x78`, `physkeyboard=rhod100_de`). Na innym telefonie te trzy wartości trzeba podmienić.

Pełna instrukcja: [docs/INSTALL.md](docs/INSTALL.md).

## Co jest w repozytorium

- HaRET, `zImage`, `initrd.gz`, `startup.txt` i `default.txt`
- konfiguracja sesji, panelu, tapety, Wicd i podświetlenia klawiatury (`config/`)
- skrypty, które nakładają tę konfigurację na lokalny obraz i składają katalog wydania
- opis sprzętu, instalacji i ograniczeń

**`debian.img` nie wchodzi do Gita.** Jest assetem wydania GitHub.

## Working on the image (host)

Never modify `images/debian-rhodium-MASTER.img`. Copy to `work/debian-rhodium-work.img` and work there.

```bash
./scripts/backup-work.sh
./scripts/apply-config.sh          # writes configs via debugfs, no loop mount
# optional, needs sudo:
./scripts/mount-image.sh
./scripts/unmount-image.sh
./scripts/build-release.sh
```

Do **not** `apt upgrade` the Squeeze userspace. The 2.6.27 kernel has previously hung (`blocked for more than 120 seconds`) after large package churn.

## 0.1.2, boot-tested

Checked on the RHOD100 after copying this image to the card:

- wallpaper from `~/.config/pcmanfm/pcmanfm.conf` (`wallpaper_mode=1`)
- bottom panel icons 40 px, packed in a row
- Wi-Fi templates are WPA2-CCMP only; Wicd turns wireless-tools `\xHH` SSIDs (Polish letters) back into real names
- keyboard backlight helper keeps `klt::keypad-bkl` on
- Openbox maximizes windows vertically so the panel does not cover Back / Save

## Limits

- The radio does **WPA2-PSK AES**. A WPA3-only access point will not associate.
- HaRET does not hand the phone a working full suspend. The power key can leave the panel black while the backlight stays on.
- Do not `apt upgrade` this Squeeze userspace. The 2.6.27 kernel has hung after large package changes.
