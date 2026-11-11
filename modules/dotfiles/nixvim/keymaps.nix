{ delib, pkgs, ... }:
delib.module {
  name = "osa.editor.nixvim";

  home.ifEnabled = {
    programs.nixvim.plugins.lz-n.enable = true;
    programs.nixvim.plugins.toggleterm = {
      enable = true;
      lazyLoad.settings.cmd = [ "ToggleTerm" ];
      lazyLoad.enable = true;
    };
    programs.nixvim.plugins.dap = {
      enable = true;
      lazyLoad.enable = true;
      lazyLoad.settings.event = "User DapCore";
    };
    programs.nixvim.plugins.dap-ui = {
      enable = true;
      lazyLoad.enable = true;
      lazyLoad.settings.event = "User DapExtras";
    };
    programs.nixvim.plugins.dap-lldb = {
      enable = true;
      lazyLoad.enable = true;
      lazyLoad.settings.event = "User DapExtras";
      settings.codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
    };

    programs.nixvim.extraConfigLua = ''
      function _G.osa_dap(command)
        vim.api.nvim_exec_autocmds("User", { pattern = "DapCore" })
        vim.api.nvim_exec_autocmds("User", { pattern = "DapExtras" })
        if command == "ui" then
          require("dapui").toggle()
        else
          vim.cmd(command)
        end
      end
    '';

    programs.nixvim.keymaps = [
      {
        mode = "n";
        key = "H";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "L";
        action = "<cmd>BufferLineCycleNext<cr>";
        options.desc = "Next buffer";
      }
      {
        mode = "n";
        key = "<leader>c";
        action = "<cmd>bdelete<cr>";
        options.desc = "Close current buffer";
      }
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<cr>";
        options.desc = "Save file";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<cr>";
        options.desc = "Close window";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Yazi<cr>";
        options.desc = "Open Yazi at the current file";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>t";
        action = "<cmd>ToggleTerm direction=float<cr>";
        options.desc = "Toggle floating terminal";
      }
      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>lua osa_dap('DapToggleBreakpoint')<cr>";
        options.desc = "Toggle breakpoint";
      }
      {
        mode = "n";
        key = "<leader>dc";
        action = "<cmd>lua osa_dap('DapContinue')<cr>";
        options.desc = "Start or continue debugging";
      }
      {
        mode = "n";
        key = "<leader>do";
        action = "<cmd>lua osa_dap('DapStepOver')<cr>";
        options.desc = "Step over";
      }
      {
        mode = "n";
        key = "<leader>di";
        action = "<cmd>lua osa_dap('DapStepInto')<cr>";
        options.desc = "Step into";
      }
      {
        mode = "n";
        key = "<leader>du";
        action = "<cmd>lua osa_dap('ui')<cr>";
        options.desc = "Toggle debugger UI";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "List buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
        options.desc = "Help tags";
      }
    ];
  };
}
