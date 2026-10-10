#!/bin/sh
# Apply KacperOS config files onto a Debian Squeeze ext2 image.
# Default target: work image (never MASTER).
# Uses debugfs so this does not require a loop mount.
set -e
. "$(dirname "$0")/common.sh"

IMG=${1:-$WORK_IMG}
need_file "$IMG"

case "$IMG" in
    *MASTER*)
        die "refusing to modify MASTER image: $IMG"
        ;;
esac

DEBUGFS=${DEBUGFS:-/usr/sbin/debugfs}
[ -x "$DEBUGFS" ] || die "debugfs not found"

write_file() {
    host="$1"
    dest="$2"
    mode="$3"
    need_file "$host"
    # debugfs "write" refuses if dest exists — unlink first, then create.
    "$DEBUGFS" -w "$IMG" -R "rm $dest" >/dev/null 2>&1 || true
    out=$("$DEBUGFS" -w "$IMG" -R "write $host $dest" 2>&1) || true
    echo "$out" | grep -Ei 'error|already|File not' || true
    if [ -n "$mode" ]; then
        "$DEBUGFS" -w "$IMG" -R "sif $dest mode $mode" >/dev/null
    fi
    case "$dest" in
        /home/user/*)
            "$DEBUGFS" -w "$IMG" -R "sif $dest uid 1001" >/dev/null
            "$DEBUGFS" -w "$IMG" -R "sif $dest gid 1001" >/dev/null
            ;;
    esac
    echo "  wrote $dest"
}

echo "Applying KacperOS $VERSION config to $IMG"

# Session / UI
write_file "$REPO_ROOT/config/xsession" /home/user/.xsession 0100755
write_file "$REPO_ROOT/config/openbox/rc.xml" /home/user/.config/openbox/rc.xml
write_file "$REPO_ROOT/config/lxpanel/panel" /home/user/.config/lxpanel/LXDE/panels/panel
# pcmanfm 0.9.7 with no --profile reads this path, not default/ or LXDE.conf.
write_file "$REPO_ROOT/config/pcmanfm/pcmanfm.conf" /home/user/.config/pcmanfm/pcmanfm.conf
write_file "$REPO_ROOT/config/pcmanfm/LXDE.conf" /home/user/.config/pcmanfm/LXDE.conf
write_file "$REPO_ROOT/config/gtk/gtkrc-2.0" /home/user/.gtkrc-2.0
write_file "$REPO_ROOT/config/lxterminal/lxterminal.conf" /home/user/.config/lxterminal/lxterminal.conf

"$DEBUGFS" -w "$IMG" -R "mkdir /home/user/.themes" >/dev/null 2>&1 || true
"$DEBUGFS" -w "$IMG" -R "sif /home/user/.themes uid 1001" >/dev/null 2>&1 || true
"$DEBUGFS" -w "$IMG" -R "sif /home/user/.themes gid 1001" >/dev/null 2>&1 || true
"$DEBUGFS" -w "$IMG" -R "mkdir /home/user/.themes/KacperOS-dark" >/dev/null 2>&1 || true
"$DEBUGFS" -w "$IMG" -R "mkdir /home/user/.themes/KacperOS-dark/openbox-3" >/dev/null 2>&1 || true
write_file "$REPO_ROOT/config/openbox/themerc" /home/user/.themes/KacperOS-dark/openbox-3/themerc

# System branding / X / nodm
write_file "$REPO_ROOT/config/xorg/xorg.conf" /etc/X11/xorg.conf
write_file "$REPO_ROOT/config/nodm/nodm" /etc/default/nodm
write_file "$REPO_ROOT/config/branding/hostname" /etc/hostname
write_file "$REPO_ROOT/config/branding/issue" /etc/issue
write_file "$REPO_ROOT/config/branding/issue.net" /etc/issue.net
write_file "$REPO_ROOT/config/locale/locale" /etc/default/locale
write_file "$REPO_ROOT/config/locale/environment" /etc/environment
write_file "$REPO_ROOT/config/autostart/sphone.desktop" /etc/xdg/autostart/sphone.desktop
write_file "$REPO_ROOT/config/rc.local" /etc/rc.local 0100755
write_file "$REPO_ROOT/config/kacperos-kbd-light" /etc/kacperos-kbd-light 0100755
write_file "$REPO_ROOT/config/sudoers.d/user" /etc/sudoers.d/user 0100440

# wl1251 rejects mixed TKIP+CCMP and wicd reports that as a bad password.
write_file "$REPO_ROOT/config/wicd/wpa" /etc/wicd/encryption/templates/wpa 0100644
write_file "$REPO_ROOT/config/wicd/wpa-psk" /etc/wicd/encryption/templates/wpa-psk 0100644
write_file "$REPO_ROOT/config/wicd/manager-settings.conf" /etc/wicd/manager-settings.conf 0100600
write_file "$REPO_ROOT/config/wicd/wicd-default" /etc/default/wicd 0100644
# Decode \\xHH SSIDs from iwlist so Polish network names match the AP.
write_file "$REPO_ROOT/config/wicd/wnettools.py" /usr/share/pyshared/wicd/wnettools.py 0100644
"$DEBUGFS" -w "$IMG" -R "rm /usr/lib/pymodules/python2.6/wicd/wnettools.pyc" >/dev/null 2>&1 || true

# Wallpaper: JPG is the runtime file (small, 800x480). PNG kept as source-quality copy.
"$DEBUGFS" -w "$IMG" -R "mkdir /usr/share/backgrounds" >/dev/null 2>&1 || true
"$DEBUGFS" -w "$IMG" -R "mkdir /usr/share/backgrounds/kacperos" >/dev/null 2>&1 || true
write_file "$REPO_ROOT/assets/wallpapers/rhodium.jpg" /usr/share/backgrounds/kacperos/rhodium.jpg
write_file "$REPO_ROOT/assets/wallpapers/rhodium.png" /usr/share/backgrounds/kacperos/rhodium.png

echo "done."
echo "Note: locale-archive on this work image already contains pl_PL.utf8."
echo "Do not run apt upgrade. Boot-test on the phone before further changes."
