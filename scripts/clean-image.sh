#!/bin/sh
# Drop machine-local junk from a mounted rootfs. Does not run apt.
set -e
. "$(dirname "$0")/common.sh"

is_mounted || die "image is not mounted at $MOUNTPOINT (run mount-image.sh)"

sudo rm -f "$MOUNTPOINT/usr/bin/qemu-arm-static"
sudo rm -f "$MOUNTPOINT/home/user/.xsession-errors"
sudo rm -rf "$MOUNTPOINT/tmp/"* "$MOUNTPOINT/var/tmp/"* 2>/dev/null || true
sudo rm -rf "$MOUNTPOINT/var/cache/apt/archives/"*.deb 2>/dev/null || true

sync
echo "cleaned $MOUNTPOINT"
