# Personal Yazi keys on top of osa.shell.yazi: archives, a terminal here, and
# "run a command over the selection".

{ delib, pkgs, ... }:
delib.module {
  name = "osa.shell.yazi";

  home.ifEnabled = {
    home.packages = [ pkgs.ouch ];

    programs.yazi = {
      plugins.run-command = ./yazi/run-command.yazi;
      plugins.archive = ./yazi/archive.yazi;

      keymap.mgr.prepend_keymap = [
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
