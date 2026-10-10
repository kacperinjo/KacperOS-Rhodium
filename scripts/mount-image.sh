#!/bin/sh
set -e
. "$(dirname "$0")/common.sh"

need_file "$WORK_IMG"
mkdir -p "$MOUNTPOINT"

if is_mounted; then
    echo "already mounted: $MOUNTPOINT"
    exit 0
fi

if [ "$(id -u)" -eq 0 ]; then
    mount -o loop,rw "$WORK_IMG" "$MOUNTPOINT"
else
    sudo mount -o loop,rw "$WORK_IMG" "$MOUNTPOINT"
fi

echo "mounted $WORK_IMG -> $MOUNTPOINT"
echo "MASTER ($MASTER_IMG) is not touched."
