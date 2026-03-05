{ config, lib, pkgs, ... }:
let
  cfg = config.services.xwayland-satellite;
in
{
  options = {
    services.xwayland-satellite = {
      enable = lib.mkEnableOption "xwayland-satellite";
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.xwayland-satellite;
        description = "xwayland-satellite package to launch in user session.";
      };
      display = lib.mkOption {
        type = lib.types.str;
        default = ":0";
        description = "DISPLAY socket exposed for X11 applications.";
      };
      sessionTarget = lib.mkOption {
        type = lib.types.str;
        default = "niri.service";
        description = "User systemd target/service that xwayland-satellite should follow.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.xwayland-satellite = {
      description = "Xwayland outside your Wayland";
      bindsTo = [ cfg.sessionTarget ];
      partOf = [ cfg.sessionTarget ];
      after = [ cfg.sessionTarget ];
      requisite = [ cfg.sessionTarget ];
      wantedBy = [ cfg.sessionTarget ];
      serviceConfig = {
        Type = "notify";
        NotifyAccess = "all";
        ExecStart = "${cfg.package}/bin/xwayland-satellite ${cfg.display}";
        Restart = "on-failure";
        RestartSec = 1;
        StandardOutput = "journal";
      };
    };
  };
}
