# osa-krozzzis

Персональная конфигурация krozzzis и реальные хосты в одном composable-флейке,
построенном поверх [osa](https://github.com/krozzzis/osa).

Флейк сразу экспортирует `nixosConfigurations`, `homeConfigurations` и
offline installer packages. При этом границы слоёв сохранены: базовая библиотека
OSA, персональные модули/rices и хосты остаются отдельными каталогами и могут
заменяться независимо.

## Структура

```
modules/user/      identity, профили, default apps, шрифты и shortcuts
modules/dotfiles/  nixvim, starship, wezterm
modules/dms/       только персональная косметика DMS (bar/widgets/control center)
rices/             выбор primary session и набор персональных desktop bundles
hosts/             nixlaptop, eeepc, pi-backup
lib/installer.nix  генерация offline installer ISO
```

Библиотека `osa` не содержит identity или машинных настроек. Сам DMS, greeter,
системные интеграции, mutable settings и значения из глобальных `osa.*`
находятся в OSA под интерфейсом `myconfig.osa.de.dms.*`. Здесь поверх него
задаются только субъективные bar/widget presets.

## Обычное использование

Репозиторий самодостаточен как host flake:

```bash
sudo nixos-rebuild switch --flake .#nixlaptop
home-manager switch --flake .#nixlaptop
```

Доступные конфигурации и installer packages:

```bash
nix flake show
nix build .#nixlaptop-niri-installer
```

## Расширение из отдельного репозитория

Публичная функция `lib.mkConfigurations` позволяет подключить этот репозиторий
целиком и добавить поверх него свои настройки и хосты:

```nix
{
  inputs.osa-krozzzis.url = "github:krozzzis/osa-krozzzis";

  outputs = inputs:
    inputs.osa-krozzzis.lib.mkConfigurations {
      moduleDirs = [
        ./modules
        ./rices
        ./hosts
      ];

      # Даёт добавленным модулям доступ к inputs текущего флейка.
      extraInputs = inputs;
      homeManagerUser = "my-user";

      # Для headless-хостов не экспортируются бессмысленные host-rice пары.
      hostsWithoutRices = [ "pi-backup" "my-server" ];
    };
}
```

По умолчанию при этом остаются доступны существующие модули, rices и хосты
krozzzis. Для независимых реализаций есть два переключателя:

```nix
inputs.osa-krozzzis.lib.mkConfigurations {
  includePersonal = false; # не подключать modules/ и rices/ krozzzis
  includeHosts = false;    # не подключать hosts/ krozzzis
  moduleDirs = [ ./modules ./rices ./hosts ];
  extraInputs = inputs;
  homeManagerUser = "my-user";
}
```

Так можно использовать только композиционный механизм и OSA, взять персональный
слой krozzzis со своими хостами или расширить весь готовый набор.

Новые flake inputs объявляются в `inputs.nix` рядом с модулем. После изменения
`inputs.nix` или `flake-file.nix` запусти:

```bash
nix run .#write-flake
nix flake lock
```

## Хосты

- `nixlaptop` — основной desktop, niri+DMS primary.
- `eeepc` — облегчённая конфигурация старого netbook.
- `pi-backup` — headless Raspberry Pi backup server.
