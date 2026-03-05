{
  lib,
  ...
}:
{
  # Keep file for rollback, but disable Sway during niri migration.
  enable = lib.mkForce false;
}
