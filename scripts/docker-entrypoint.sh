#!/bin/sh
set -e

# Under rootless podman, the container's "root" (uid 0) is a mapping into the
# host's running user — already an unprivileged user from the kernel's view.
# The gosu downgrade-to-node pattern was for rootful Docker, where in-container
# root was actual root and dropping privileges mattered. Under rootless it
# accomplishes nothing security-wise AND it remaps the process to a subuid
# (e.g. host uid 100999) that doesn't own any of the bind-mounted host paths
# (e.g. /srv/agent-instructions/<world>/), breaking spawned tools that read
# them. Detect rootless via /proc/self/uid_map — if uid 0 inside maps to a
# non-zero host uid, we're rootless — and exec the command directly so the
# whole app runs as that host user.
if [ -r /proc/self/uid_map ]; then
    HOST_UID_FOR_ROOT=$(awk '$1==0 {print $2; exit}' /proc/self/uid_map)
    if [ -n "$HOST_UID_FOR_ROOT" ] && [ "$HOST_UID_FOR_ROOT" -ne 0 ]; then
        exec "$@"
    fi
fi

# Rootful path: remap node's uid/gid if requested, fix volume ownership, and
# drop privileges to node via gosu.
PUID=${USER_UID:-1000}
PGID=${USER_GID:-1000}

# Adjust the node user's UID/GID if they differ from the runtime request
# and fix volume ownership only when a remap is needed
changed=0

if [ "$(id -u node)" -ne "$PUID" ]; then
    echo "Updating node UID to $PUID"
    usermod -o -u "$PUID" node
    changed=1
fi

if [ "$(id -g node)" -ne "$PGID" ]; then
    echo "Updating node GID to $PGID"
    groupmod -o -g "$PGID" node
    usermod -g "$PGID" node
    changed=1
fi

if [ "$changed" = "1" ]; then
    chown -R node:node /paperclip
fi

exec gosu node "$@"
