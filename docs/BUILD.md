# Budowa release

Repozytorium **nie** zawiera `debian.img` (ok. 1,9 GB, limit Gita to 100 MB). Publiczne wydanie dokleja ten plik jako asset GitHub Release. Lokalny katalog release składa się z bootfiles + work image.

## Artefakt

```
KacperOS-Rhodium-VERSION/
  HARET-DEBIAN.EXE
  startup.txt
  zImage
  initrd.gz
  debian.img
  README.txt
```

```bash
cd KacperOS-Rhodium
./scripts/apply-config.sh
./scripts/build-release.sh
```

Domyślne ścieżki (katalog nadrzędny repo):

| zmienna | domyślnie |
| --- | --- |
| `WORK_IMG` | `../work/debian-rhodium-work.img` |
| `MASTER_IMG` | `../images/debian-rhodium-MASTER.img` (tylko odczyt / kopia awaryjna) |
| `RELEASES_DIR` | `../releases` |

Kompresja opcjonalna: `tar.xz`, `zip`, `7z`.

## Wersjonowanie

Plik [`VERSION`](../VERSION) w korzeniu repo. Katalog release bierze tę wartość.

Podbijaj VERSION przy publicznym wydaniu, nie przy każdej próbie na telefonie.

## Czego nie robić

- `apt upgrade` / masowe `apt install` / `apt purge`
- podmiana kernela na „nowszy Debian”
- `rsync` zamontowanego rootfs z `/proc` `/sys` `/dev` (kiedyś wpadło `/proc/kcore`)
- zapis do pliku MASTER
