#!/bin/sh
set -e
. "$(dirname "$0")/common.sh"

if ! is_mounted; then
    echo "not mounted: $MOUNTPOINT"
    exit 0
fi

# Never leave qemu helper or bind-mounts behind.
if mount | grep -q " $MOUNTPOINT/dev/pts "; then
    sudo umount "$MOUNTPOINT/dev/pts" || true
fi
if mount | grep -q " $MOUNTPOINT/dev "; then
    sudo umount "$MOUNTPOINT/dev" || true
fi
if mount | grep -q " $MOUNTPOINT/sys "; then
    sudo umount "$MOUNTPOINT/sys" || true
fi
if mount | grep -q " $MOUNTPOINT/proc "; then
    sudo umount "$MOUNTPOINT/proc" || true
fi

sudo rm -f "$MOUNTPOINT/usr/bin/qemu-arm-static"
sync

if [ "$(id -u)" -eq 0 ]; then
    umount "$MOUNTPOINT"
else
    sudo umount "$MOUNTPOINT"
fi

echo "unmounted $MOUNTPOINT"
