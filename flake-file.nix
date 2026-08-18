{ lib, ... }:
let
  flakeInputs = import ./lib/flake-inputs.nix { inherit lib; };
  moduleDirs = [
    ./modules
    ./rices
  ];
in
{
  description = "osa-user -- krozzzis's personal config (identity, desktop/server profiles, rice presets, dotfiles) built on top of the osa module library.";

  imports = flakeInputs.importModules moduleDirs;

  # See ../osa/flake-file.nix for why this shim looks like this.
  flake-file.outputs = ''
    inputs:
      let
        evaluated = inputs.nixpkgs.lib.evalModules {
          specialArgs = { inherit inputs; inherit (inputs) self; };
          modules = [ inputs.flake-file.flakeModules.flake ./flake-file.nix ];
        };
        base = evaluated.config.outputs inputs;
        system = "x86_64-linux";
        pkgs = import inputs.nixpkgs { inherit system; };
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

  # Bootstrap set: nixpkgs/home-manager/denix/flake-file (needed to eval at
  # all) plus osa itself (this flake's modules read/extend `osa.*` options
  # declared there). Everything a dotfiles/rice module needs beyond that
  # would get its own sibling inputs.nix, same as in osa -- none currently
  # do (they only reference `myconfig.osa.*`, not raw flake inputs).
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

  # Like osa itself, this flake doesn't build nixosConfigurations -- it's a
  # module library consumed via `${inputs.osa-user}/modules` +
  # `${inputs.osa-user}/rices` by whatever flake owns the hosts.
  outputs = _inputs: { };
}
