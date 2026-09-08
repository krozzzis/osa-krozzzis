{ delib, ... }:
delib.rice {
  name = "hyprland";

  # Compatibility alias: a bare compositor is not a complete rice anymore,
  # so the old name selects the Hyprland+Caelestia bundle.
  myconfig = {
    osa.de.rice.primary = "caelestia";
    osa.de.rice.caelestia.enable = true;
  };
}
