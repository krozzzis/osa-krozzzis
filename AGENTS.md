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
