{ delib, lib, pkgs, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = { myconfig, ... }:
    let
      enabledServers = lib.filterAttrs (_name: srv: srv.enable) myconfig.user.dev.lsp;

      nixvimOverrides = {
        "rust-analyzer" = {
          installCargo = false;
          installRustc = false;
        };
      };

      mkServer = name: server:
        { enable = true; package = null; }
        // lib.optionalAttrs (server.settings != { }) { settings = server.settings; }
        // (nixvimOverrides.${name} or { });
    in
    {
      programs.nixvim = {
        plugins.lsp = {
          enable = true;

          servers = builtins.listToAttrs (map (name: {
            name = lib.replaceStrings [ "-" ] [ "_" ] name;
            value = mkServer name myconfig.user.dev.lsp.${name};
          }) (builtins.attrNames enabledServers));

          keymaps = {
            silent = true;

            lspBuf = {
              gd = {
                action = "definition";
                desc = "Go to definition";
              };
              gD = {
                action = "declaration";
                desc = "Go to declaration";
              };
              gr = {
                action = "references";
                desc = "References";
              };
              gi = {
                action = "implementation";
                desc = "Go to implementation";
              };
              K = {
                action = "hover";
                desc = "Hover documentation";
              };
              "<leader>ca" = {
                action = "code_action";
                desc = "Code action";
              };
              "<leader>rn" = {
                action = "rename";
                desc = "Rename symbol";
              };
            };
          };
        };
      };
    };
}
