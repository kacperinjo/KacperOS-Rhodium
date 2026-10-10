#!/bin/sh
# Shared paths for KacperOS Rhodium helper scripts.
# Override with environment variables when needed.

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PROJECT_ROOT=${PROJECT_ROOT:-$(CDPATH= cd -- "$REPO_ROOT/.." && pwd)}

WORK_IMG=${WORK_IMG:-$PROJECT_ROOT/work/debian-rhodium-work.img}
MASTER_IMG=${MASTER_IMG:-$PROJECT_ROOT/images/debian-rhodium-MASTER.img}
MOUNTPOINT=${MOUNTPOINT:-$PROJECT_ROOT/mounts/debian}
RELEASES_DIR=${RELEASES_DIR:-$PROJECT_ROOT/releases}
BACKUP_DIR=${BACKUP_DIR:-$PROJECT_ROOT/backups/work}
VERSION=$(cat "$REPO_ROOT/VERSION" 2>/dev/null || echo 0.0.0)

die() {
    echo "error: $*" >&2
    exit 1
}

need_file() {
    [ -f "$1" ] || die "missing file: $1"
}

is_mounted() {
    mount | grep -q " $MOUNTPOINT "
}
