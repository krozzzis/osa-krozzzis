# osa-krozzzis — инструкции для агентов

Этот репозиторий — downstream-конфигурация OSA: здесь находятся пользовательские
настройки, rices и реальные хосты. Переиспользуемые модули и интерфейс
`myconfig.osa.*` находятся в `~/osa`.

## OSA CLI

Для обновления, сборки и переключения конфигураций используй установленную
команду `osa`. По умолчанию она работает с `~/osa-user`; другой downstream-flake
задаётся через `--config`:

```bash
osa update
osa switch nixlaptop-niri
osa update-switch --run0 nixlaptop-niri
osa update-boot --config ~/osa-user nixlaptop-niri
osa build-iso pi-backup
osa build-installer nixlaptop-niri
```

Команда сама выполняет `nix run .#write-flake` там, где нужна регенерация.
Запускай CLI от обычного пользователя. Для операций, которым нужен root,
предпочитай launcher `run0`: `osa switch --run0 <configuration>` либо
`run0 <command>`. Не запускай от root весь агентский workflow.

После изменения `inputs.nix` или `flake-file.nix` не редактируй сгенерированный
`flake.nix` вручную. Основная проверка хоста:

```bash
nix eval .#nixosConfigurations.nixlaptop-niri.config.system.build.toplevel.drvPath
```
