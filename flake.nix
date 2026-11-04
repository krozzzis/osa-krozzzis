{
  description = "osa-krozzzis -- composable personal configuration and host flake built on OSA.";

  outputs =
    { denix, osa, ... }@inputs:
    let
      nixpkgsLib = inputs.nixpkgs.lib;
      subpath = input: path: /. + (builtins.unsafeDiscardStringContext (input.outPath + path));
      filteredDir =
        dir:
        /.
        + (builtins.unsafeDiscardStringContext (
          builtins.path {
            path = dir;
            filter = path: _type: baseNameOf path != "inputs.nix";
          }
        ));
      osaRoot = filteredDir (subpath osa "");
      personalRoot = filteredDir ./.;

      # Public composition point for downstream modules and hosts.
      mkConfigurations =
        {
          moduleDirs ? [ ],
          extraInputs ? { },
          homeManagerUser ? "krozzzis",
          includePersonal ? true,
          includeHosts ? true,
          hostsWithoutRices ? [ "pi-backup" ],
          # When supplied, host names and architectures are known without
          # evaluating every machine just to discover installer outputs.
          installerHosts ? null,
        }:
        let
          moduleInputs = inputs // extraInputs;
          localDirs =
            nixpkgsLib.optionals includeHosts [ (personalRoot + "/hosts") ]
            ++ nixpkgsLib.optionals includePersonal [
              (personalRoot + "/modules")
              (personalRoot + "/rices")
            ];
          paths = [ (osaRoot + "/modules") ] ++ localDirs ++ map filteredDir moduleDirs;

          mkFor =
            moduleSystem:
            (import (osaRoot + "/lib/configurations.nix") { inputs = moduleInputs; }) {
              inherit moduleSystem homeManagerUser paths;
              extensions = with denix.lib.extensions; [
                args
                (base.withConfig { args.enable = true; })
              ];
              specialArgs.inputs = moduleInputs;
            };

          isRiceVariant =
            prefix: name:
            nixpkgsLib.any (host: nixpkgsLib.hasPrefix "${prefix}${host}-" name) hostsWithoutRices;
          nixosConfigurationsBase = nixpkgsLib.filterAttrs (name: _cfg: !(isRiceVariant "" name)) (
            mkFor "nixos"
          );
          homeConfigurations = nixpkgsLib.filterAttrs (
            name: _cfg: !(isRiceVariant "${homeManagerUser}@" name)
          ) (mkFor "home");
          isInstallable =
            _name: cfg:
            let
              system = cfg.config.nixpkgs.hostPlatform.system;
            in
            (system == "x86_64-linux" || system == "i686-linux")
            && (cfg.config ? disko)
            && cfg.config.disko.devices.disk != { };
          installerHost =
            name:
            let
              matches = nixpkgsLib.filter (host: name == host || nixpkgsLib.hasPrefix "${host}-" name) (
                builtins.attrNames installerHosts
              );
              longestFirst = nixpkgsLib.sort (a: b: builtins.stringLength a > builtins.stringLength b) matches;
            in
            if longestFirst == [ ] then null else builtins.head longestFirst;
          installableTargets = nixpkgsLib.filterAttrs (
            if installerHosts == null then isInstallable else name: _: installerHost name != null
          ) nixosConfigurationsBase;
          mkInstaller = import ./lib/installer.nix { inputs = moduleInputs; };
          installerConfigurations = nixpkgsLib.mapAttrs' (
            name: target:
            nixpkgsLib.nameValuePair "${name}-installer" (
              if
                installerHosts == null
                || (
                  isInstallable name target
                  && target.config.nixpkgs.hostPlatform.system == installerHosts.${installerHost name}
                )
              then
                mkInstaller {
                  targetName = name;
                  inherit target;
                }
              else
                throw "Installer ${name}: expected a supported system and a non-empty disko configuration matching installerHosts."
            )
          ) installableTargets;
          installerPackages = nixpkgsLib.foldl' (
            acc: name:
            let
              target = installableTargets.${name};
              system =
                if installerHosts == null then
                  target.config.nixpkgs.hostPlatform.system
                else
                  installerHosts.${installerHost name};
            in
            nixpkgsLib.recursiveUpdate acc {
              ${system}."${name}-installer" =
                installerConfigurations."${name}-installer".config.system.build.isoImage;
            }
          ) { } (builtins.attrNames installableTargets);
        in
        {
          nixosConfigurations = nixosConfigurationsBase // installerConfigurations;
          inherit homeConfigurations;
          packages = installerPackages;
        };

      ownConfigurations = mkConfigurations {
        installerHosts = {
          eeepc = "x86_64-linux";
          nixlaptop = "x86_64-linux";
        };
      };
    in
    ownConfigurations
    // {
      lib = { inherit mkConfigurations; };
    };

  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    conflux-icon-theme = {
      url = "github:MoshiurRahmanAdib/Conflux-Icon-Theme";
      flake = false;
    };
    dankcalendar = {
      url = "github:AvengeMedia/dankcalendar";
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs = {
        home-manager.follows = "home-manager";
      };
    };
    disko = {
      url = "github:nix-community/disko";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
    };
    elephant.url = "github:abenz1267/elephant";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
    };
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-26.05";
    };
    kkfetch = {
      url = "github:kk376/kkfetch";
    };
    koala-clash = {
      url = "github:endotrizine/koala-clash-nix";
    };
    niri-pkgs = {
      url = "github:sodiboo/niri-flake";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    nixpkgs.follows = "nixpkgs-stable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    ntfsplus = {
      url = "github:cmspam/ntfsplus-flake";
    };
    osa.url = "github:krozzzis/osa";
    plymouth-theme-material = {
      url = "github:krozzzis/plymouth-theme-material";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    };
    rip = {
      url = "github:cesarferreira/rip";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    winapps = {
      url = "github:winapps-org/winapps";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        home-manager.follows = "home-manager";
      };
    };
  };
}
