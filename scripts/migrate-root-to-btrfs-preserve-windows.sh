#!/usr/bin/env bash
set -euo pipefail

DISK="${DISK:-/dev/nvme0n1}"
ESP_PART="${ESP_PART:-${DISK}p1}"
ROOT_PART="${ROOT_PART:-${DISK}p2}"
HOST_NAME="${HOST_NAME:-bin}"
FLAKE_PATH="${FLAKE_PATH:-$(pwd)}"
MNT="${MNT:-/mnt}"
SWAP_SIZE="${SWAP_SIZE:-2G}"
ASSUME_YES="${ASSUME_YES:-0}"

usage() {
  cat <<'EOF'
Usage:
  migrate-root-to-btrfs-preserve-windows.sh [options]

Options:
  --disk <device>        Target disk (default: /dev/nvme0n1)
  --esp <partition>      EFI partition (default: <disk>p1)
  --root <partition>     Linux root partition to convert (default: <disk>p2)
  --host <name>          Flake host name (default: bin)
  --flake <path>         Flake path (default: current directory)
  --mountpoint <path>    Temporary mountpoint (default: /mnt)
  --swap-size <size>     Swapfile size in btrfs swap subvol (default: 2G)
  -y, --yes              Skip interactive confirmation
  -h, --help             Show this help

Environment variables with same names are also supported:
  DISK ESP_PART ROOT_PART HOST_NAME FLAKE_PATH MNT SWAP_SIZE ASSUME_YES

Safety:
  - Only formats ROOT_PART.
  - Does not repartition or wipe the whole DISK.
  - Leaves Windows NTFS partitions untouched.
EOF
}

log() {
  printf '[migrate] %s\n' "$*"
}

die() {
  printf '[migrate][error] %s\n' "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --disk)
      DISK="$2"
      shift 2
      ;;
    --esp)
      ESP_PART="$2"
      shift 2
      ;;
    --root)
      ROOT_PART="$2"
      shift 2
      ;;
    --host)
      HOST_NAME="$2"
      shift 2
      ;;
    --flake)
      FLAKE_PATH="$2"
      shift 2
      ;;
    --mountpoint)
      MNT="$2"
      shift 2
      ;;
    --swap-size)
      SWAP_SIZE="$2"
      shift 2
      ;;
    -y|--yes)
      ASSUME_YES=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

if [[ "${EUID}" -ne 0 ]]; then
  die "run as root"
fi

for c in lsblk blkid mkfs.btrfs btrfs mount umount findmnt awk grep sed nixos-install; do
  need_cmd "$c"
done

[[ -b "${DISK}" ]] || die "disk not found: ${DISK}"
[[ -b "${ESP_PART}" ]] || die "EFI partition not found: ${ESP_PART}"
[[ -b "${ROOT_PART}" ]] || die "root partition not found: ${ROOT_PART}"
[[ -f "${FLAKE_PATH}/flake.nix" ]] || die "flake.nix not found at: ${FLAKE_PATH}"

root_src="$(findmnt -no SOURCE / || true)"
if [[ "${root_src}" == "${ROOT_PART}" ]]; then
  die "ROOT_PART is currently mounted as /; boot into installer/live system first"
fi

mapfile -t win_parts < <(lsblk -rno PATH,FSTYPE "${DISK}" | awk '$2 == "ntfs" {print $1}')
declare -A win_uuid_before
for p in "${win_parts[@]:-}"; do
  win_uuid_before["$p"]="$(blkid -s UUID -o value "$p" 2>/dev/null || true)"
done

log "target disk: ${DISK}"
log "EFI partition: ${ESP_PART}"
log "Linux root partition to convert: ${ROOT_PART}"
log "flake: ${FLAKE_PATH}#${HOST_NAME}"
if ((${#win_parts[@]} > 0)); then
  log "detected Windows partitions: ${win_parts[*]}"
else
  log "warning: no NTFS partitions detected on ${DISK}"
fi

lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINTS -f "${DISK}"

if [[ "${ASSUME_YES}" != "1" ]]; then
  echo
  echo "This will FORMAT ${ROOT_PART} as btrfs and reinstall NixOS from ${FLAKE_PATH}#${HOST_NAME}."
  echo "Windows partitions are not formatted by this script."
  read -r -p 'Type "YES" to continue: ' answer
  [[ "${answer}" == "YES" ]] || die "aborted by user"
fi

log "unmounting previous mounts under ${MNT} (if any)"
swapoff -a || true
for mp in "${MNT}/boot" "${MNT}/.swapvol" "${MNT}/nix" "${MNT}/home" "${MNT}"; do
  if findmnt "${mp}" >/dev/null 2>&1; then
    umount -R "${mp}" || true
  fi
done
mkdir -p "${MNT}"

log "formatting ${ROOT_PART} to btrfs"
mkfs.btrfs -f -L nix-root "${ROOT_PART}"

log "creating btrfs subvolumes"
mount "${ROOT_PART}" "${MNT}"
for subvol in rootfs home nix swap; do
  btrfs subvolume create "${MNT}/${subvol}"
done
umount "${MNT}"

log "mounting target filesystem layout"
mount -o subvol=rootfs "${ROOT_PART}" "${MNT}"
mkdir -p "${MNT}/home" "${MNT}/nix" "${MNT}/.swapvol" "${MNT}/boot"
mount -o subvol=home,compress=zstd "${ROOT_PART}" "${MNT}/home"
mount -o subvol=nix,compress=zstd,noatime "${ROOT_PART}" "${MNT}/nix"
mount -o subvol=swap "${ROOT_PART}" "${MNT}/.swapvol"
mount -t vfat -o umask=0077 "${ESP_PART}" "${MNT}/boot"

log "creating swapfile in btrfs subvolume"
btrfs filesystem mkswapfile --size "${SWAP_SIZE}" "${MNT}/.swapvol/swapfile"

log "installing NixOS from flake"
nixos-install --root "${MNT}" --flake "${FLAKE_PATH}#${HOST_NAME}" --no-root-password

sync

if ((${#win_parts[@]} > 0)); then
  log "verifying Windows partition UUIDs unchanged"
  for p in "${win_parts[@]}"; do
    before="${win_uuid_before["$p"]}"
    after="$(blkid -s UUID -o value "$p" 2>/dev/null || true)"
    if [[ "${before}" != "${after}" ]]; then
      die "Windows partition UUID changed unexpectedly: ${p} (${before} -> ${after})"
    fi
  done
fi

log "done. root converted to btrfs, Windows partitions preserved."
log "you can reboot now."
