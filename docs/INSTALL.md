# Instalacja KacperOS Rhodium na karcie SD

## Wymagania

- HTC Touch Pro2 (Rhodium **RHOD100**) z Windows Mobile
- karta microSD sformatowana jako **FAT32**
- pliki z wydania **0.1.2** (boot z repozytorium albo z release, `debian.img` z release)

Initrd montuje **wyłącznie** `/sdcard/debian.img`. Plik musi leżeć w **katalogu głównym** karty, nie w podfolderze.

## Pliki na karcie (root FAT32)

```
HARET-DEBIAN.EXE
startup.txt
default.txt
zImage
initrd.gz
debian.img
```

`HARET-DEBIAN.EXE` czyta **`startup.txt`**. Zwykły `HaRET.EXE` z XDAndroid często czyta **`default.txt`**. Oba pliki w tym wydaniu są **identyczne** (boot KacperOS, nie Android).

Nazwa obrazu **musi** brzmieć `debian.img`.

## Boot

1. Włóż kartę.
2. W Windows Mobile otwórz eksplorator plików karty.
3. Uruchom `HARET-DEBIAN.EXE`.
4. HaRET ładuje `zImage` + `initrd.gz` według `startup.txt`.
5. Initrd: FAT32 → loop `debian.img` (ext2, rw) → `switch_root`.
6. `nodm` loguje użytkownika `user` i startuje `~/.xsession`.

## Nie zmieniaj bez powodu

W `startup.txt` zostaw m.in.:

- `mtype 2292`
- `physkeyboard=rhod100_de`
- `msmts_calib=0x9f.0x39a.0x35c.0x78`
- `recalibrate=false`

To kalibracja dotyku i mapa fizycznej QWERTY z działającego portu.

## Po starcie

- pulpit: Openbox + panel na dole
- Wi-Fi: ikona Wicd w tacku. Sieć z polskimi literami w SSID da się wybrać. Hasło wpisz od nowa po wgraniu świeżego obrazu.
- Chip wl1251 łączy się przez **WPA2-PSK (AES)**. Samo WPA3 nie zadziała.
- znaki polskie: `locale` powinno pokazać `pl_PL.UTF-8`
- układ klawiatury w tym cmdline to `rhod100_de` (niemiecka matryca QWERTY z portu)
