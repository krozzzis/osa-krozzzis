{ inputs, lib, ... }:
let
  flakeInputs = import ./lib/flake-inputs.nix { inherit lib; };

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

  realOutputs =
    { denix, osa, ... }@inputs:
    let
      nixpkgsLib = inputs.nixpkgs.lib;
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
          installableTargets = nixpkgsLib.filterAttrs isInstallable nixosConfigurationsBase;
          mkInstaller = import ./lib/installer.nix { inputs = moduleInputs; };
          installerConfigurations = nixpkgsLib.mapAttrs' (
            name: target:
            nixpkgsLib.nameValuePair "${name}-installer" (mkInstaller {
              targetName = name;
              inherit target;
            })
          ) installableTargets;
          installerPackages = nixpkgsLib.foldl' (
            acc: name:
            let
              target = installableTargets.${name};
              system = target.config.nixpkgs.hostPlatform.system;
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

      ownConfigurations = mkConfigurations { };
    in
    ownConfigurations
    // {
      lib = { inherit mkConfigurations; };
    };
in
{
  description = "osa-krozzzis -- composable personal configuration and host flake built on OSA.";

  imports =
    flakeInputs.importModules [
      ./modules
      ./rices
      ./hosts
    ]
    ++ lib.optionals (inputs ? osa) (flakeInputs.importModules [ (subpath inputs.osa "/modules") ]);

  flake-file.outputs = ''
    inputs:
      let
        evaluated = inputs.nixpkgs.lib.evalModules {
          specialArgs = { inherit inputs; inherit (inputs) self; };
          modules = [ inputs.flake-file.flakeModules.flake ./flake-file.nix ];
        };
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs { inherit system; };
        haveAllInputs = builtins.all (name: inputs ? ''${name}) (
          builtins.attrNames evaluated.config.flake-file.inputs
        );
        base = if haveAllInputs then evaluated.config.outputs inputs else { };
      in
      base // {
        packages = (base.packages or { }) // {
          ''${system} = (base.packages.''${system} or { }) // {
            write-flake = evaluated.config.flake-file.apps.write-flake pkgs;
          };
        };
        checks = (base.checks or { }) // {
          ''${system} = (base.checks.''${system} or { }) // {
            flake-file-in-sync = evaluated.config.flake-file.check-flake-file pkgs;
          };
        };
      }
  '';

  flake-file.inputs = {
    nixpkgs.follows = "nixpkgs-stable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    flake-file.url = "github:vic/flake-file";
    osa.url = "github:krozzzis/osa";
  };

  outputs = realOutputs;
}
