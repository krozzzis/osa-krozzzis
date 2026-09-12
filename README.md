# osa-krozzzis

Personal settings and real hosts composed on top of
[OSA](https://github.com/krozzzis/osa). The flake exports NixOS and Home
Manager configurations plus offline installer packages while keeping reusable
OSA modules, personal preferences and host hardware in separate layers.

## Layout

```text
modules/user/      identity, profiles, default applications, fonts and shortcuts
modules/dotfiles/  personal application settings
modules/dms/       cosmetic DMS bar, widget and control-center presets
rices/             desktop bundles and primary-session selection
hosts/             hardware, storage, networking and boot configuration
lib/installer.nix  offline installer image builder
```

OSA owns DMS packages, greeter and system integration, mutable settings
machinery and global UI defaults. This repository only supplies subjective
presets and machine-specific values.

## Usage

The `osa` CLI uses `~/osa-user` by default:

```bash
osa update
osa switch nixlaptop-niri
osa update-switch nixlaptop-niri
osa build-iso pi-backup
osa build-installer nixlaptop-niri
```

Run it as the normal user. The CLI elevates only NixOS activation through
systemd `run0`.

## Composition API

`lib.mkConfigurations` lets another flake reuse or extend this repository:

```nix
inputs.osa-user.url = "github:krozzzis/osa-krozzzis";

outputs = inputs:
  inputs.osa-user.lib.mkConfigurations {
    moduleDirs = [ ./modules ./hosts ];
    extraInputs = inputs;
  };
```

Set `includePersonal = false` to omit the personal modules and rices, or
`includeHosts = false` to omit the bundled hosts. New flake inputs belong in an
`inputs.nix` beside their consumer. Regenerate `flake.nix` after changing an
input declaration.

## Hosts

- `nixlaptop`: primary desktop, using Niri and DMS.
- `eeepc`: lightweight configuration for an older netbook.
- `pi-backup`: headless backup appliance and image target.
