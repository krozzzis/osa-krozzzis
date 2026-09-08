{ ... }:
{
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake-file.inputs.lyrics-visualizer = {
    url = "path:/home/krozzzis/dev/lyrics_vusializer";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake-file.inputs.nixos-hardware = {
    url = "github:NixOS/nixos-hardware";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake-file.inputs.plymouth-theme-material = {
    url = "github:krozzzis/plymouth-theme-material";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
