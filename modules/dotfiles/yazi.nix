# Personal Yazi keys on top of osa.shell.yazi: archives, a terminal here, and
# "run a command over the selection".

{ delib, pkgs, ... }:
delib.module {
  name = "osa.shell.yazi";

  home.ifEnabled = {
    home.packages = [ pkgs.ouch ];

    programs.yazi = {
      plugins.starship = {
        package = pkgs.fetchFromGitHub {
          owner = "Rolv-Apneseth";
          repo = "starship.yazi";
          rev = "ea92cf49380466f07231c952b409831e6afd2156";
          hash = "sha256-Jvoc/7YaOOppu8K2lJaVgiuBIyanRHHjEA6ZvnrFtiQ=";
        };
        setup = false;
      };
      plugins.run-command = ./yazi/run-command.yazi;
      plugins.archive = ./yazi/archive.yazi;

      keymap.mgr.prepend_keymap = [
        {
          on = "<Esc>";
          run = "quit";
          desc = "Close Yazi";
        }
        {
          on = "C";
          run = "plugin archive compress";
          desc = "Compress selection to archive";
        }
        {
          on = "E";
          run = "plugin archive extract";
          desc = "Extract selected archives here";
        }
        {
          on = "T";
          run = "shell --block $SHELL";
          desc = "Open terminal in current directory";
        }
        {
          on = "R";
          run = "plugin run-command";
          desc = "Run command on selection";
        }
      ];
    };
  };
}
