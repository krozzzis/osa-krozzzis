# Same helper as ../osa/lib/flake-inputs.nix -- collects sibling
# `inputs.nix` files so a module can declare the flake input it needs
# without hand-editing this flake's flake.nix.
{ lib }:
rec {
  findPaths =
    dirs:
    lib.filter (path: baseNameOf path == "inputs.nix") (lib.concatMap lib.filesystem.listFilesRecursive dirs);

  importModules = dirs: map (path: import path) (findPaths dirs);
}
