# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "osa-user -- krozzzis's personal config (identity, desktop/server profiles, rice presets, dotfiles) built on top of the osa module library.";

  outputs =
    inputs:
    let
      evaluated = inputs.nixpkgs.lib.evalModules {
        specialArgs = {
          inherit inputs;
          inherit (inputs) self;
        };
        modules = [
          inputs.flake-file.flakeModules.flake
          ./flake-file.nix
        ];
      };
      base = evaluated.config.outputs inputs;
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    base
    // {
      packages = (base.packages or { }) // {
        ${system} = (base.packages.${system} or { }) // {
          write-flake = evaluated.config.flake-file.apps.write-flake pkgs;
        };
      };
      checks = (base.checks or { }) // {
        ${system} = (base.checks.${system} or { }) // {
          flake-file-in-sync = evaluated.config.flake-file.check-flake-file pkgs;
        };
      };
    };

  inputs = {
    denix = {
      url = "github:yunfachi/denix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-file.url = "github:vic/flake-file";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    osa.url = "path:/home/krozzzis/osa";
  };
}
