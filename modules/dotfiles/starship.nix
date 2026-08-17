# Extends osa.shell.starship (declared+enabled in the osa flake) with the
# actual prompt format/theme -- same module name, no `options`, see
# denix's module merging in modules/configurations/module.nix.
{ delib, lib, ... }:
delib.module {
  name = "osa.shell.starship";

  home.ifEnabled = { myconfig, ...}:
  let
    cfg = myconfig.osa.shell.starship;
    inherit (lib) optionalAttrs recursiveUpdate;

    nerdFontPreset = {
      aws.symbol = "";
      azure.symbol = "";
      battery.full_symbol = "󰁹";
      battery.charging_symbol = "󰂄";
      battery.discharging_symbol = "󰂃";
      battery.unknown_symbol = "󰂑";
      battery.empty_symbol = "󰂎";
      buf.symbol = "";
      bun.symbol = "";
      c.symbol = "";
      cpp.symbol = "";
      cmake.symbol = "";
      cobol.symbol = "";
      conda.symbol = "";
      container.symbol = "";
      crystal.symbol = "";
      dart.symbol = "";
      deno.symbol = "";
      direnv.symbol = "";
      directory.read_only = " 󰌾";
      docker_context.symbol = "";
      dotnet.symbol = "";
      elixir.symbol = "";
      elm.symbol = "";
      erlang.symbol = "";
      fennel.symbol = "";
      fortran.symbol = "";
      fossil_branch.symbol = "";
      gcloud.symbol = "󱇶";
      git_branch.symbol = "";
      git_commit.tag_symbol = "";
      gleam.symbol = "";
      golang.symbol = "";
      gradle.symbol = "";
      guix_shell.symbol = "";
      haskell.symbol = "";
      haxe.symbol = "";
      helm.symbol = "";
      hg_branch.symbol = "";
      hostname.ssh_symbol = "";
      java.symbol = "";
      julia.symbol = "";
      kotlin.symbol = "";
      kubernetes.symbol = "󱃾";
      lua.symbol = "";
      maven.symbol = "";
      memory_usage.symbol = "󰍛";
      meson.symbol = "󰔷";
      mojo.symbol = "󰈸";
      nats.symbol = "";
      netns.symbol = "󰛳";
      nim.symbol = "";
      nix_shell.symbol = "";
      nodejs.symbol = "";
      ocaml.symbol = "";
      odin.symbol = "󰟢";
      opa.symbol = "";
      openstack.symbol = "";
      os.disabled = false;
      os.symbols = {
        AIX = "";
        AlmaLinux = "";
        Alpaquita = "";
        Alpine = "";
        ALTLinux = "";
        Amazon = "";
        Android = "";
        AOSC = "";
        Arch = "";
        Artix = "";
        Bluefin = "";
        CachyOS = "";
        CentOS = "";
        Debian = "";
        DragonFly = "";
        Elementary = "";
        Emscripten = "";
        EndeavourOS = "";
        Fedora = "";
        FreeBSD = "";
        Garuda = "";
        Gentoo = "";
        HardenedBSD = "󰞌";
        Illumos = "";
        InstantOS = "";
        Ios = "󰀷";
        Kali = "";
        Linux = "";
        Mabox = "";
        Macos = "";
        Manjaro = "";
        Mariner = "";
        MidnightBSD = "";
        Mint = "";
        NetBSD = "";
        NixOS = "";
        Nobara = "";
        OpenBSD = "";
        OpenCloudOS = "";
        openEuler = "";
        openSUSE = "";
        OracleLinux = "󰺡";
        PikaOS = "";
        Pop = "";
        Raspbian = "";
        Redhat = "󱄛";
        RedHatEnterprise = "󱄛";
        Redox = "󰀘";
        RockyLinux = "";
        Solus = "";
        SUSE = "";
        Ubuntu = "";
        Ultramarine = "";
        Unknown = "";
        Uos = "";
        Void = "";
        Windows = "󰍲";
        Zorin = "";
      };
      package.symbol = "󰏗";
      perl.symbol = "";
      php.symbol = "";
      pijul_channel.symbol = "";
      pixi.symbol = "󰏗";
      pulumi.symbol = "";
      purescript.symbol = "";
      python.symbol = "";
      raku.symbol = "󱖊";
      red.symbol = "󱍼";
      rlang.symbol = "󰟔";
      ruby.symbol = "";
      rust.symbol = "󱘗";
      scala.symbol = "";
      shlvl.symbol = "󰹍";
      singularity.symbol = "";
      solidity.symbol = "";
      spack.symbol = "";
      status.symbol = "";
      sudo.symbol = "";
      swift.symbol = "";
      terraform.symbol = "";
      vlang.symbol = "";
      typst.symbol = "";
      vagrant.symbol = "";
      xmake.symbol = "";
      zig.symbol = "";
    };
  in
  {
    programs.starship = {
      settings = recursiveUpdate
        {
          format = "[$username@$hostname](bold green) [$directory](bold blue)$git_branch$character";
          add_newline = false;

          character = {
            format = "$symbol";
            success_symbol = "> ";
            error_symbol = "> ";
          };

          username = {
            show_always = true;
            style_root = "bold red";
            format = "[$user]($style)";
          };

          hostname = {
            ssh_only = false;
            style = "bold green";
            format = "[$hostname]($style)";
          };

          directory = {
            style = "bold blue";
            read_only = " 󰌾";
            fish_style_pwd_dir_length = 1;
            truncation_length = 2;
            truncate_to_repo = false;
          };

          git_branch = {
            disabled = false;
            format = "[\\($branch\\)]($style)";
          };

          package.disabled = false;
        }
        (optionalAttrs cfg.useNerdFonts nerdFontPreset);
    };
  };
}
