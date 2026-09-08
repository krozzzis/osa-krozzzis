# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "osa-krozzzis -- composable personal configuration and host flake built on OSA.";

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
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
      haveAllInputs = builtins.all (name: inputs ? ${name}) (
        builtins.attrNames evaluated.config.flake-file.inputs
      );
      base = if haveAllInputs then evaluated.config.outputs inputs else { };
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
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        quickshell.follows = "quickshell";
      };
    };
    denix = {
      url = "github:yunfachi/denix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    elephant.url = "github:abenz1267/elephant";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.url = "github:vic/flake-file";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lyrics-visualizer = {
      url = "path:/home/krozzzis/dev/lyrics_vusializer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-pkgs = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ntfsplus = {
      url = "github:cmspam/ntfsplus-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    osa.url = "github:krozzzis/osa";
    plymouth-theme-material = {
      url = "github:krozzzis/plymouth-theme-material";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rip = {
      url = "github:cesarferreira/rip";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
