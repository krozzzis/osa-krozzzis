{ delib, ... }:
delib.host {
  name = "nixlaptop";

  nixos = {
    boot = {
      initrd.systemd.enable = true;

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };

      plymouth = {
        enable = true;
        theme = "material";
      };

      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "udev.log_level=3"
        "systemd.show_status=auto"
        # AMD Lucienne (Renoir) iGPU wedges on s2idle resume: the display
        # pipeline comes back but the greeter/compositor stays frozen. Keeping
        # the GPU out of runtime power management makes resume reliable.
        "amdgpu.runpm=0"
      ];
    };
  };
}
