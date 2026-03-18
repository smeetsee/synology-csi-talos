#!/usr/bin/env bash
# This script is only used in the container, see Dockerfile.

DIR="/host" # csi-node mount / of the node to /host in the container
BIN="$(basename "$0")"
iscsid_pid=$(pgrep iscsid)

if [ -d "$DIR" ]; then
    echo "entering nsenter" # env is not available in Talos, because there aren't any shells
    nsenter --mount="/proc/${iscsid_pid}/ns/mnt" --net="/proc/${iscsid_pid}/ns/net" -- "/usr/local/sbin/$BIN" "$@"
else
    echo -n "Couldn't find hostPath: $DIR in the CSI container /usr/local/sbin/$BIN $@"
    exit 1
fi
