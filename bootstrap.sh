#!/usr/bin/env bash
# Mount the games SSDs and run the restore script stored on them.
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/crowquillx/tandesk-bootstrap/main/bootstrap.sh)
set -euo pipefail

[[ $EUID -eq 0 ]] && { echo "Run as your user, not root."; exit 1; }

mount_disk() {
  local uuid=$1 mp=$2
  sudo mkdir -p "$mp"
  if ! findmnt -rn "$mp" >/dev/null; then
    sudo mount "UUID=$uuid" "$mp"
  fi
  echo "mounted $mp"
}

mount_disk a93a28c3-8538-45f9-9031-1d740a0993f1 /mnt/games
mount_disk 59ad586e-b4ed-4e44-bda1-2412e5e5b9e3 /mnt/games1

restore=/mnt/games1/tandesk-backup/repo/restore.sh
[[ -f $restore ]] || { echo "$restore not found"; exit 1; }
exec bash "$restore" "$@"
