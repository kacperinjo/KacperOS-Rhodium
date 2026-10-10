#!/bin/sh
# Assemble a FAT32-ready release directory. Does not modify MASTER.
set -e
. "$(dirname "$0")/common.sh"

need_file "$WORK_IMG"
need_file "$REPO_ROOT/boot/zImage"
need_file "$REPO_ROOT/boot/initrd.gz"
need_file "$REPO_ROOT/boot/startup.txt"
need_file "$REPO_ROOT/boot/default.txt"
need_file "$REPO_ROOT/boot/HARET-DEBIAN.EXE"

NAME="KacperOS-Rhodium-${VERSION}"
OUT="$RELEASES_DIR/$NAME"
mkdir -p "$OUT"

cp -a "$REPO_ROOT/boot/HARET-DEBIAN.EXE" "$OUT/"
cp -a "$REPO_ROOT/boot/startup.txt" "$OUT/"
cp -a "$REPO_ROOT/boot/default.txt" "$OUT/"
cp -a "$REPO_ROOT/boot/zImage" "$OUT/"
cp -a "$REPO_ROOT/boot/initrd.gz" "$OUT/"
cp -a "$WORK_IMG" "$OUT/debian.img"

cat > "$OUT/README.txt" <<EOF
KacperOS Rhodium ${VERSION}
===========================

Copy these files to the ROOT of a FAT32 microSD card:

  HARET-DEBIAN.EXE
  startup.txt
  default.txt
  zImage
  initrd.gz
  debian.img

debian.img MUST sit in the card root (the initrd looks for /sdcard/debian.img).

On the phone (Windows Mobile): run HARET-DEBIAN.EXE from the card.

This build is a custom Debian Squeeze userspace with a historical
HTC/XDAndroid 2.6.27 kernel. See the git repository LICENSES/ and README.md.

Do not run apt upgrade on device.
EOF

sync
echo "release directory: $OUT"
echo "Optional compress:"
echo "  tar -C $RELEASES_DIR -cJf $RELEASES_DIR/${NAME}.tar.xz $NAME"
echo "  zip -r $RELEASES_DIR/${NAME}.zip $OUT"
