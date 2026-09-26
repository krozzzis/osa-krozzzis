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
lib/installer.nix  offline installer image builder, using the target system channel
```

OSA owns DMS packages, greeter and system integration, mutable settings
machinery and global UI defaults. This repository supplies subjective presets, application channel choices and
machine-specific values.

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


## System and application versions

[`modules/user/packageChannels.nix`](modules/user/packageChannels.nix) owns the
personal channel policy. The system uses NixOS **26.05 stable**; 26.11 is not a
stable release as of September 2026. Application packages default to unstable.

| Channel | Applications |
| --- | --- |
| Stable | RustDesk, Arduino IDE, LibreOffice, Kdenlive, OBS, MuseScore, LSP Plugins, audio patchbay bundle |
| Unstable | Audacity, Wine, Zed, Neovim, Zen, DMS dependencies, Quickshell, other applications by default |

Inside a denix `myconfig` definition:

```nix
osa.system.nixpkgs = "stable";
osa.nixpkgs.default = "unstable";
osa.apps.rustdesk.nixpkgs = "stable";
osa.apps.wine.nixpkgs = "unstable";
osa.media.audacity.nixpkgs = "unstable";
```

`"system"` uses the host package set, including its overlays. Additional inputs
named `nixpkgs-<name>` become selectable channels. For example, declare
`flake-file.inputs.nixpkgs-2605.url = "github:nixos/nixpkgs/nixos-26.05"`,
regenerate the flake and select `"2605"`. Change the stable input's URL when
adopting a later stable release. Lock files pin exact revisions until updated.

The Wine package's `wineWow64Packages.stable` attribute names its upstream
release flavor; it is still taken from nixpkgs unstable. Channels do not alter
Wine prefixes. Audio patchbay dependencies stay with that bundle's own channel.
`.pkg` overrides still win; OBS and Neovim plugins follow their application's
package set. Zen and DMS keep their separately pinned source inputs; selecting
nixpkgs changes their build dependencies, not their source version.

DMS uses the cached Quickshell release from unstable; the greeter shares these
packages with the desktop session. Keep their channels aligned for Qt plugin
compatibility. The system builder uses OSA's channel-aware composition helper,
and each offline installer uses its target's selected NixOS release. The stable
oo7 compatibility module keeps the keyring integration and uses host libraries
for PAM. Home Manager remains on master for current application options and
therefore emits a release-version warning on stable hosts.

## Binary caches

The Nix daemon shares its caches across all applications and nixpkgs channels:

- `cache.nixos.org`: standard stable/unstable packages, available on all hosts
  and live installer images.
- `niri.cachix.org`: configured by OSA's imported Niri module.
- `walker.cachix.org` and `walker-git.cachix.org`: when Walker is enabled.
- `nix-community.cachix.org`: when Nixvim is enabled.
- `winapps.cachix.org`: when WinApps is enabled.

OSA supplies the project public keys and retains signature verification.
Dependency flakes' `nixConfig` settings alone do not enable their caches.
Configured cache access does not guarantee a hit: OSA patches to DMS/Niri,
custom build variants, wrappers and the oo7 PAM backport can require builds.
Quickshell for DMS uses the nixpkgs package to benefit from the official cache.

```bash
# Desired settings, including both standard and extra cache/key lists.
nix eval --json .#nixosConfigurations.nixlaptop-niri.config.nix.settings
# Active settings for the Nix process performing the build.
nix config show | rg '^(extra-)?(substituters|trusted-public-keys)|^substitute '
# Check the exact selected derivation before installing/updating.
nix path-info --store https://cache.nixos.org /nix/store/<exact-package-path>
nix build --dry-run .#nixosConfigurations.nixlaptop-niri.config.system.build.toplevel
```

New daemon settings apply after `osa switch`, not during configuration
evaluation. Standalone Home Manager uses the host daemon's cache/trust policy;
its administrator must enable any missing project caches. Offline installers
already contain the target closure and retain the official cache for their
live environment.

## Coordinated OSA development

The OSA input is `github:krozzzis/osa`; keep this dependency independent of a
local OSA checkout. Test changes before publishing OSA with:

```bash
nix eval .#nixosConfigurations.nixlaptop-niri.config.system.build.toplevel.drvPath \
  --override-input osa ~/osa
```

Publish the OSA commit first, update this repository's OSA input with
`osa update-osa`, then check it without overrides and publish this repository.
`flake.nix` is generated; change `flake-file.nix` or module-local `inputs.nix`,
then run `nix run .#write-flake`. When a new OSA input changes available module
inputs, regenerate again and update the lock file before validating.

Useful checks are `nix build --no-link .#checks.x86_64-linux.flake-file-in-sync`,
toplevel evaluation for `nixlaptop-niri` and `pi-backup`, and `git diff --check`.
These evaluate configuration and check generated files; they do not activate the
system or prove that every customized package builds or runs successfully.
