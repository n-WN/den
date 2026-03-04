# Preserve Windows + Migrate NixOS Root to Btrfs

This repository now supports a non-destructive migration path:
- Keep existing Windows partitions as-is.
- Reformat only Linux root partition (`/dev/nvme0n1p2`) to btrfs.
- Reinstall NixOS from flake host `bin`.

## What changed in config

- `hosts/bin/disko.nix`
  - `destroy = false` on `disk.main` to avoid whole-disk wipe in disko destroy stage.
  - `/boot` and `/` now use explicit existing partition devices:
    - EFI: `/dev/nvme0n1p1`
    - Root: `/dev/nvme0n1p2`

This removes runtime dependency on GPT partlabels for mounting, which avoids boot-time device wait failures from label mismatch.

## Migration command

Run from a NixOS installer/live environment (not from the running system on `p2`):

```bash
cd /path/to/den
sudo ./scripts/migrate-root-to-btrfs-preserve-windows.sh --host bin --flake "$(pwd)" -y
```

Default behavior:
- Only formats `/dev/nvme0n1p2`.
- Creates btrfs subvolumes: `rootfs`, `home`, `nix`, `swap`.
- Creates swapfile at `/.swapvol/swapfile` (2G).
- Mounts EFI from `/dev/nvme0n1p1`.
- Runs `nixos-install --flake .#bin`.
- Verifies Windows NTFS partition UUIDs did not change.

## Safety notes

- The script does **not** repartition the disk.
- The script does **not** format NTFS partitions.
- Data on Linux root partition (`p2`) is destroyed by design.
