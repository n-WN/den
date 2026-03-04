{
  # Temporary: do not declare runtime disko layout on this host.
  # The machine currently boots from ext4 (/dev/nvme0n1p2), and the previous
  # disko declaration expected /dev/disk/by-partlabel/disk-main-root which
  # does not exist, causing boot-time device timeout/emergency mode.
}
