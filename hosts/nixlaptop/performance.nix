{
  delib,
  config,
  lib,
  pkgs,
  ...
}:
delib.host {
  name = "nixlaptop";

  myconfig = {
    # Ryzen 5 5500U is Zen 2: znver4 kernels require newer instructions.
    osa.system.cachyos = {
      enable = true;
      variant = "lto";
    };
    # The audio module otherwise selects performance even when on battery.
    osa.system.audio.performanceGovernor = false;
  };

  nixos = {
    boot.kernelParams = [
      "amd_pstate=active"
      "preempt=full"
    ];

    # Prefer compressed RAM to random NVMe swap IO under desktop load.
    # Disk swap remains available for hibernation and overflow.
    zramSwap = {
      algorithm = "zstd";
      memoryPercent = 50;
      priority = 100;
    };
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkForce 100;
      "vm.page-cluster" = 0;
    };
    services.fstrim.enable = true;

    # Bound competing IO latency on this laptop's NVMe, without changing
    # USB storage or applying CPU-specific tuning to other hosts.
    services.udev.extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="nvme[0-9]*n[0-9]*", ENV{DEVTYPE}=="disk", ATTR{queue/scheduler}="mq-deadline"
      ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${pkgs.systemd}/bin/systemctl --no-block restart laptop-power-profile.service"
    '';

    # Update only at boot, resume and AC transitions. Manual profile changes
    # from DMS stay in effect until the next power-source transition.
    systemd.services.laptop-power-profile = {
      description = "Select laptop power profile for the current power source";
      wantedBy = [
        "multi-user.target"
        "post-resume.target"
      ];
      after = [ "power-profiles-daemon.service" ];
      requires = [ "power-profiles-daemon.service" ];
      serviceConfig = {
        Type = "oneshot";
        RuntimeDirectory = "laptop-power-profile";
        RuntimeDirectoryPreserve = "yes";
      };
      script = ''
        profile=power-saver
        for supply in /sys/class/power_supply/*; do
          [ -r "$supply/type" ] && [ -r "$supply/online" ] || continue
          if [ "$(cat "$supply/type")" = Mains ] && [ "$(cat "$supply/online")" = 1 ]; then
            profile=balanced
            break
          fi
        done
        state=/run/laptop-power-profile/source-profile
        if [ -r "$state" ] && [ "$(cat "$state")" = "$profile" ]; then
          exit 0
        fi
        ${lib.getExe' config.services.power-profiles-daemon.package "powerprofilesctl"} set "$profile"
        printf '%s' "$profile" > "$state"
      '';
    };
  };
}
