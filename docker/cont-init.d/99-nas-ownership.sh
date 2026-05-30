#!/command/with-contenv sh
# NAS customization. Upstream's 01-hermes-setup (stage2-hook.sh) remaps the
# hermes UID and chowns /opt/data, but not /opt/hermes. The NAS runtime writes
# under /opt/hermes at start (hermes-vault-run patches plugins/.../dist), so the
# install dir must be owned by the remapped hermes user. Runs as root in
# cont-init, numbered 99 to execute after the UID remap.
set -eu

INSTALL_DIR="/opt/hermes"
HERMES_UID="${HERMES_UID:-${PUID:-}}"

if [ -n "$HERMES_UID" ] && [ "$HERMES_UID" != "10000" ]; then
    echo "[nas-ownership] chown $INSTALL_DIR to hermes ($(id -u hermes))"
    chown -R hermes:hermes "$INSTALL_DIR" 2>/dev/null || \
        echo "[nas-ownership] WARNING: chown $INSTALL_DIR failed"
fi
