# osa-krozzzis agent guide

This repository is the personal downstream layer for OSA. It owns identity,
preferences, rice selection and real hosts. Reusable modules and the public
`myconfig.osa.*` interface live in `~/osa`.

## Workflow

Use the installed `osa` command as the normal user. It defaults to this
repository and invokes `run0` only for privileged NixOS activation.

```bash
osa update
osa switch nixlaptop-niri
osa update-switch nixlaptop-niri
osa build-iso pi-backup
osa build-installer nixlaptop-niri
```

Never edit generated `flake.nix`. After changing `flake-file.nix` or an
`inputs.nix`, run `nix run .#write-flake` or use an `osa` command that does so.

Keep modules declarative and concise. Prefer typed OSA handles directly, for
example `user.editor.default = myconfig.osa.editor.nixvim`. Do not redeclare
the `user.*` contract downstream. Machine hardware belongs in `hosts/`, shared
personal behavior in `modules/`, and session selection in `rices/`.

Validate a host against the local OSA checkout with:

```bash
nix eval .#nixosConfigurations.nixlaptop.config.system.build.toplevel.drvPath \
  --override-input osa ~/osa
```


## Package channels

`modules/user/packageChannels.nix` is the authoritative personal policy:

- System: `stable` (`nixos-26.05`); applications default to `unstable`.
- Stable exceptions: RustDesk, Arduino IDE, LibreOffice, Kdenlive, OBS,
  MuseScore, LSP Plugins and the audio patchbay bundle.
- Audacity and Wine explicitly use unstable, as do Zed, Neovim, Zen and DMS.
  DMS's Quickshell package follows unstable and is shared with its greeter.
- `wineWow64Packages.stable` denotes the Wine flavor, not stable nixpkgs.
  Do not change the flavor or Wine prefixes when changing the channel.

Set `osa.<category>.<application>.nixpkgs = "stable"` / `"unstable"` / `"system"`.
Additional `nixpkgs-<name>` inputs expose named release selectors automatically.
Existing `.pkg` overrides remain authoritative. Keep plugins on the same package
set as their host application and do not put system-wide unstable overlays here.

The composition function uses OSA's `lib/configurations.nix` so the system
selector changes both modules and packages. `lib/installer.nix` follows each
target's selected channel. Root `nixpkgs` follows `nixpkgs-stable`; application
flake inputs normally follow `nixpkgs-unstable`. Keep generated `flake.nix` and
`flake.lock` synchronized with input declarations.

OSA is consumed from `github:krozzzis/osa`. For coordinated changes, publish OSA
first, then update this repository's OSA lock entry and validate without local
input overrides before publishing this repository. Local evaluation with
`--override-input osa ~/osa` remains useful before the OSA commit is published.
Do not leave a machine-specific `path:/home/...` OSA input in a published flake.

## Binary caches and checks

NixOS provides `cache.nixos.org` on every host and live installer. OSA owns
project caches: Niri, Walker, Nixvim (`nix-community`) and WinApps. Add upstream
URLs and verified public keys in OSA's consuming module, not in personal cosmetic
presets. Cache lists are global to the build machine, shared by stable/unstable
applications; a dependency flake's `nixConfig` is not automatically inherited.

Audit both `substituters`/`extra-substituters` and
`trusted-public-keys`/`extra-trusted-public-keys` in evaluated configurations.
Also inspect active `nix config show`: new daemon settings apply only after
activation. Confirm exact package availability with `nix path-info --store URL
PATH`; patched packages and configured wrappers may still build locally.
Standalone Home Manager uses its host daemon's caches.

After channel/cache changes, evaluate the affected desktop and `pi-backup`,
check installer release/cache settings, run the generated-flake sync check and
`git diff --check`. OSA's flake check covers both system channels. Home Manager
currently remains on master, so stable hosts emit a release-version warning;
evaluation checks do not claim a successful runtime activation.
