# Personal Yazi keys on top of osa.shell.yazi: archives, a terminal here, and
# "run a command over the selection".
#
# `ouch` picks the archive format from the extension, so the compress prompt
# accepts `.zip`, `.tar.gz`, `.7z`, ... alike. Paths are splatted by Yazi
# (`%s` = selection, or the hovered file when nothing is selected).
{ delib, pkgs, ... }:
delib.module {
  name = "osa.shell.yazi";

  home.ifEnabled = {
    home.packages = [ pkgs.ouch ];

    programs.yazi = {
      plugins.run-command = ./yazi/run-command.yazi;

      keymap.mgr.prepend_keymap = [
        {
          on = "C";
          # Cursor sits right before `.zip`, so typing replaces the name while
          # leaving the extension editable for ouch.
          run = "shell --interactive 'ouch compress %s .zip' --cursor=17";
          desc = "Compress selection to archive";
        }
        {
          on = "E";
          run = "shell --block 'ouch decompress --here %s'";
          desc = "Extract selected archives here";
        }
        {
          on = "T";
          # OSA exports TERMINAL for the default emulator; the child inherits
          # the current directory, and --orphan keeps it alive after Yazi exits.
          run = "shell --orphan $TERMINAL";
          desc = "Open terminal in current directory";
        }
        {
          on = "R";
          run = "plugin run-command";
          desc = "Run command on selection ($1, $2, ...)";
        }
      ];
    };
  };
}
