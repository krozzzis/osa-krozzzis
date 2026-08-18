# osa-krozzzis

krozzzis's personal configuration layer, built on top of the
[osa](https://github.com/krozzzis/osa) module library: identity, user-level
profile toggles (shell/gui/server/desktop), default-app choices, and rice
(desktop environment) presets. Like `osa`, this flake declares no hosts and
builds no `nixosConfigurations` by itself — it's consumed by a hosts flake
(see [osa-hosts](https://github.com/krozzzis/osa-hosts), private).

## Layout

```
modules/user/      profile modules: identity, gui/shell/server/desktop
                    toggles, default apps, fonts, dev, layout, shortcuts
modules/dotfiles/   dotfile-shaped config for specific tools (nixvim,
                    starship, wezterm)
rices/              DE presets: niri, hyprland, xfce, caelestia
```

Modules are namespaced `myconfig.user.*` (vs. `myconfig.osa.*` for the
library modules in `osa`). `modules/user/identity.nix` hardcodes the
identity (username `krozzzis`, full name, email) — fork this repo and
change that file if you want your own identity on top of `osa`.

## Enabling this configuration

Add both `osa` and this flake as inputs, and feed their module dirs into
denix alongside your host's own:

```nix
inputs = {
  osa.url = "github:krozzzis/osa";
  osa-user.url = "github:krozzzis/osa-krozzzis";
  # osa-user's own flake-file.inputs already points `osa` at github:krozzzis/osa
};

# in outputs:
paths = [
  ./hosts
  "${osa}/modules"
  "${osa-user}/modules"
  "${osa-user}/rices"
];
```

(`osa-hosts` does this today — see its `flake-file.nix` for the working
wiring, including the `subpath`/`filteredDir` helpers needed because
`paths` spans three separate flakes' store trees.)

### Shell-only (server) profile

For a headless/CLI machine, enable just the shell layer:

```nix
myconfig.user.shell.enable = true;
```

This pulls in the `osa.shell.*` CLI utilities (fish/zsh, eza, fzf, ripgrep,
...) with no desktop environment. `user.server.enable = true` is a step
further: it turns on `user.shell` plus OpenSSH (key-only, no password/root
login) — appropriate for a machine you only ever reach over SSH.

### GUI (desktop) profile

```nix
myconfig.user.desktop.enable = true;
```

`user.desktop` is a meta-toggle that enables both `user.gui` and
`user.shell`. `user.gui.enable` on its own turns on GUI-flavored modules
(most `osa.apps`/`osa.media`/`osa.browser`/`osa.ai` modules default to
`myconfig.user.gui.enable`, so enabling GUI mode brings in a full desktop
app set unless you disable specific modules per-host). You then also need
a **rice** to actually get a desktop environment — GUI mode alone doesn't
pick one:

```nix
rice = "niri";       # or "hyprland", "xfce", "caelestia"
```

set on the `delib.host` in your hosts flake. Rices turn on the matching
`osa.de.*` module (and, for niri, the DMS shell + walker launcher; for
hyprland/caelestia, SDDM + a polkit agent).

### Applying to a host

A full example (abbreviated from `osa-hosts/hosts/nixlaptop/default.nix`):

```nix
{ delib, lib, ... }:
delib.host {
  name = "nixlaptop";
  rice = "niri";

  myconfig = { myconfig, ... }: {
    user.dev.enable = true;
    user.desktop.enable = true;

    user.shell.default = myconfig.osa.shell.fish;
    user.editor.default = myconfig.osa.editor.nixvim;
    user.browser.default = myconfig.osa.browser.zenBrowser;
    # ... user.fileManager.default, user.imageViewer.default, etc.

    osa.editor.nixvim.enable = true;
    # ... turn individual osa.* modules on/off per-host
  };

  home.home.stateVersion = "26.05";
  nixos.system.stateVersion = "26.05";
}
```

`user.*.default` options (terminal/editor/browser/fileManager/musicPlayer/
videoPlayer/...) pick which enabled `osa.*` module's package backs that
role — set per-host since e.g. eeepc prefers `vim` over `nixvim` for a
lighter footprint.
