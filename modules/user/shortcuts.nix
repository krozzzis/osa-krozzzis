{ delib, lib, ... }:
let
  inherit (lib) types;
in
delib.module {
  name = "user.shortcuts";

  options = { ... }: {
    user.shortcuts = lib.mkOption {
      type = types.listOf (types.submodule {
        options = {
          enable = lib.mkOption {
            type = types.bool;
            default = true;
          };
          mod = lib.mkOption {
            type = types.listOf types.str;
            default = [ ];
          };
          key = lib.mkOption {
            type = types.str;
          };
          action = lib.mkOption {
            type = types.attrs;
          };
          title = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          cooldownMs = lib.mkOption {
            type = types.nullOr types.int;
            default = null;
          };
        };
      });
      default = [ ];
    };
  };
}
