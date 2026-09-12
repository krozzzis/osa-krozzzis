{ delib, lib, ... }:
let
  inherit (lib) types;
  wm = { mod = [ "Mod" ]; };
  wmShift = { mod = [ "Mod" "Shift" ]; };
  wmCtrl = { mod = [ "Mod" "Ctrl" ]; };
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

  myconfig.always = { myconfig, ... }: let
    inherit (lib) getName;
    app = pkg: { spawn = [ (getName pkg) ]; };
  in {
    user.shortcuts = [
      # -- volume
      { key = "XF86AudioRaiseVolume";  action = { spawn = [ "pamixer" "-i" "5" ]; }; title = "Volume Up"; }
      { key = "XF86AudioLowerVolume";  action = { spawn = [ "pamixer" "-d" "5" ]; }; title = "Volume Down"; }
      { key = "XF86AudioMute";         action = { spawn = [ "pamixer" "-t" ]; };    title = "Volume Mute"; }
      { key = "XF86AudioMicMute";      action = { spawn = [ "pamixer" "--default-source" "-t" ]; }; title = "Mic Mute"; }

      # -- brightness
      { key = "XF86MonBrightnessUp";   action = { spawn = [ "brightnessctl" "set" "+5%" ]; }; title = "Brightness Up"; }
      { key = "XF86MonBrightnessDown"; action = { spawn = [ "brightnessctl" "set" "5%-" ]; }; title = "Brightness Down"; }

      # -- overview
      (wm // { key = "Tab"; action = { toggle-overview = [ ]; }; })

      # -- close
      (wmShift // { key = "C"; action = { close-window = [ ]; }; })

      # -- focus
      (wm // { key = "Left";  action = { focus-column-left = [ ]; }; })
      (wm // { key = "Down";  action = { focus-window-or-workspace-down = [ ]; }; })
      (wm // { key = "Up";    action = { focus-window-or-workspace-up = [ ]; }; })
      (wm // { key = "Right"; action = { focus-column-right = [ ]; }; })
      (wm // { key = "H";     action = { focus-column-left = [ ]; }; })
      (wm // { key = "J";     action = { focus-window-or-workspace-down = [ ]; }; })
      (wm // { key = "K";     action = { focus-window-or-workspace-up = [ ]; }; })
      (wm // { key = "L";     action = { focus-column-right = [ ]; }; })

      # -- move
      (wmShift // { key = "Left";  action = { move-column-left = [ ]; }; })
      (wmShift // { key = "Down";  action = { move-window-down-or-to-workspace-down = [ ]; }; })
      (wmShift // { key = "Up";    action = { move-window-up-or-to-workspace-up = [ ]; }; })
      (wmShift // { key = "Right"; action = { move-column-right = [ ]; }; })
      (wmShift // { key = "H";     action = { move-column-left = [ ]; }; })
      (wmShift // { key = "J";     action = { move-window-down-or-to-workspace-down = [ ]; }; })
      (wmShift // { key = "K";     action = { move-window-up-or-to-workspace-up = [ ]; }; })
      (wmShift // { key = "L";     action = { move-column-right = [ ]; }; })

      # -- page up/down
      (wm // { key = "Page_Down"; action = { focus-workspace-down = [ ]; }; })
      (wm // { key = "Page_Up";   action = { focus-workspace-up = [ ]; }; })
      (wmCtrl // { key = "Page_Down"; action = { move-column-to-workspace-down = [ ]; }; })
      (wmCtrl // { key = "Page_Up";   action = { move-column-to-workspace-up = [ ]; }; })
      (wmShift // { key = "Page_Down"; action = { move-workspace-down = [ ]; }; })
      (wmShift // { key = "Page_Up";   action = { move-workspace-up = [ ]; }; })

      # -- scroll
      (wm // { key = "WheelScrollDown";   cooldownMs = 150; action = { focus-workspace-down = [ ]; }; })
      (wm // { key = "WheelScrollUp";     cooldownMs = 150; action = { focus-workspace-up = [ ]; }; })
      (wm // { key = "TouchpadScrollDown"; cooldownMs = 150; action = { focus-workspace-down = [ ]; }; })
      (wm // { key = "TouchpadScrollUp";   cooldownMs = 150; action = { focus-workspace-up = [ ]; }; })

      # -- column/window actions
      (wm // { key = "Comma";       action = { consume-or-expel-window-left = [ ]; }; })
      (wm // { key = "Period";      action = { consume-or-expel-window-right = [ ]; }; })
      (wm // { key = "R";           action = { switch-preset-column-width = [ ]; }; })
      (wmShift // { key = "R";      action = { switch-preset-window-height = [ ]; }; })
      (wmCtrl // { key = "R";       action = { reset-window-height = [ ]; }; })
      (wm // { key = "F";           action = { maximize-column = [ ]; }; })
      (wm // { key = "M";           action = { fullscreen-window = [ ]; }; })
      (wm // { key = "C";           action = { center-column = [ ]; }; })
      (wm // { key = "BracketLeft";  action = { set-column-width = "-10%"; }; })
      (wm // { key = "BracketRight"; action = { set-column-width = "+10%"; }; })
      (wmShift // { key = "BracketLeft";  action = { set-window-height = "-10%"; }; })
      (wmShift // { key = "BracketRight"; action = { set-window-height = "+10%"; }; })
      (wm // { key = "Space";       action = { toggle-window-floating = [ ]; }; })

      # -- screenshots
      { key = "Print"; action = { screenshot = [ ]; }; }
      (wmShift // { key = "S"; action = { screenshot = [ ]; }; })
      { mod = [ "Ctrl" ]; key = "Print"; action = { screenshot-screen = [ ]; }; }
      { mod = [ "Alt" ];  key = "Print"; action = { screenshot-window = [ ]; }; }

      # -- quit
      (wmShift // { key = "E"; action = { quit = [ ]; }; })
      { mod = [ "Ctrl" "Alt" ]; key = "Delete"; action = { quit = [ ]; }; }

      # -- app spawns
      (wm // { key = "Return"; action = app myconfig.user.terminal.default.pkg; title = "Open Terminal"; })
      (wm // { key = "P";      action = app myconfig.osa.de.niri.launcher.default.pkg; title = "Open Launcher"; })
      (wm // { key = "E";      action = app myconfig.user.fileManager.default.pkg; title = "Open File Manager"; })
      (wmCtrl // { key = "L";  action = app myconfig.user.browser.default.pkg; title = "Open Browser"; })
    ];
  };
}
