# Development — ostrożnie

Kernel 2.6.27 + Squeeze jest **wrażliwy**. Duży ruch w apt (install/purge/upgrade, Wheezy, własne rootfs) kończył się zwisami:

```
task ... blocked for more than 120 seconds
```

Przywrócenie MASTER-a to naprawiało. Dlatego:

1. Backup `work.img` przed zmianą (`./scripts/backup-work.sh`).
2. Jedna zmiana, potem boot na telefonie.
3. Żadnego `apt upgrade`.
4. GUI: Openbox + LXPanel + PCManFM — bez Phosha i pełnego ciężkiego DE.
5. Nie ruszaj `xorg.conf` `Rotate CW` ani parametrów HaRET bez powodu.

## MASTER vs work

| plik | rola |
| --- | --- |
| `images/debian-rhodium-MASTER.img` | awaryjna baza — **nie zapisywać** |
| `work/debian-rhodium-work.img` | jedyny obraz do edycji |

## Montowanie (sudo)

```bash
M=../mounts/debian
IMG=../work/debian-rhodium-work.img
sudo mount -o loop,rw "$IMG" "$M"
# ... edycja ...
sync
sudo umount "$M"
```

Konfigurację sesji można wgrać **bez** mounta: `./scripts/apply-config.sh` (debugfs).

## Chroot ARM (qemu-arm-static)

Laptop jest x86_64. Po pracy **zawsze** odmontuj `proc`/`sys`/`dev`/`dev/pts` i usuń `qemu-arm-static` **zanim** skopiujesz obraz.

```bash
M=/home/kacper/htc-rhodium/mounts/debian
sudo cp /usr/bin/qemu-arm-static "$M/usr/bin/"
sudo mount -t proc proc "$M/proc"
sudo mount -t sysfs sys "$M/sys"
sudo mount --bind /dev "$M/dev"
sudo mount -t devpts devpts "$M/dev/pts"
sudo chroot "$M" /bin/bash
# exit
sudo umount "$M/dev/pts" "$M/dev" "$M/sys" "$M/proc"
sudo rm -f "$M/usr/bin/qemu-arm-static"
sync
sudo umount "$M"
```

`locale-gen` uruchamiaj tylko w tym chrootcie, jeśli `locale-archive` nie zawiera `pl_PL.utf8`. Na work image z 2026-10-08 archive już to ma.

## UI

- `.xsession` musi być wykonywalny (`chmod +x`).
- `nodm`: `NODM_ENABLED=true`, `NODM_USER=user`.
- Openbox: `<number>1</number>` w `<desktops>`.
- Nie startuj `lxsession` — sesja jest ręczna (panel + pcmanfm --desktop + openbox).
- Autostart `sphone` jest wyłączony (`Hidden=true`), żeby nie otwierać okna telefonu.

## Test locale

```sh
locale
printf 'Zażółć gęślą jaźń\n'
```
