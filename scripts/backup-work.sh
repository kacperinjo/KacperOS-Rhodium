#!/bin/sh
set -e
. "$(dirname "$0")/common.sh"

need_file "$WORK_IMG"
mkdir -p "$BACKUP_DIR"
STAMP=$(date +%Y-%m-%d-%H%M)
DEST="$BACKUP_DIR/debian-rhodium-work-${STAMP}.img"
cp -a --reflink=auto "$WORK_IMG" "$DEST"
echo "backup: $DEST"
echo "md5:"
md5sum "$WORK_IMG" "$DEST"
