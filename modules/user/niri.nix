{ delib, lib, ... }:
delib.module {
  name = "user.niri";

  home.always = { myconfig, ... }: {
    imports = [
      ({ config, ... }: {
        config = lib.mkIf myconfig.osa.de.rice.niri.enable {
          xdg.configFile.niri-config =
            let
              finalConfig = config.programs.niri.finalConfig;
            in
            lib.mkForce {
              target = "niri/hm.kdl";
              text =
                let
                  shake = ''
                    shake {
                      on
                      max-multiplier 10.0
                      post-expand-delay-ms 150
                      expand-duration-ms 150
                      decay-duration-ms 250
                      shake-interval-ms 350
                      min-diagonal 80.0
                      sensitivity 2.5
                    }
                  '';
                  ghosttyBlur = ''
                    window-rule {
                      match app-id="^com\\.mitchellh\\.ghostty$"
                      background-effect {
                        blur true
                      }
                    }
                  '';
                in
                assert lib.hasInfix "cursor {" finalConfig;
                assert lib.hasInfix "input {" finalConfig;
                (lib.replaceStrings
                  [ "cursor {" "input {" ]
                  [ "cursor {\n${shake}" "input {\n  focus-follows-mouse max-scroll-amount=\"0%\"" ]
                  finalConfig
                ) + "\n" + ghosttyBlur;
            };
        };
      })
    ];
  };
}
