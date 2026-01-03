{ pkgs, ... }:

let
  # Workaround for installing continue extension
  # https://github.com/Ifaen/NixOS/blob/82fafec9e655ae652e3193514cbc90377dd6e36e/software/vscode/extensions.nix
  continue =
        pkgs.vscode-utils.buildVscodeMarketplaceExtension
        {
          mktplcRef = {
            name = "continue";
            publisher = "Continue";
          version = "1.1.40";
            sha256 = "sha256-P4rhoj4Juag7cfB9Ca8eRmHRA10Rb4f7y5bNGgVZt+E=";
            arch = "linux-x64";
          };
          # Patch obtained from: https://github.com/continuedev/continue/issues/821
          nativeBuildInputs = [pkgs.autoPatchelfHook];
          buildInputs = [pkgs.stdenv.cc.cc.lib];
        };
  extensions = (with pkgs.vscode-extensions; [
    arrterian.nix-env-selector
    bbenoist.nix
    bmewburn.vscode-intelephense-client
    bradlc.vscode-tailwindcss
    brettm12345.nixfmt-vscode
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    mhutchie.git-graph
    mkhl.direnv
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-containers
    ms-vscode.live-server
    ms-vsliveshare.vsliveshare
    redhat.vscode-yaml
    rust-lang.rust-analyzer
    serayuzgur.crates
    tamasfe.even-better-toml
    tomoki1207.pdf
    twxs.cmake
    usernamehw.errorlens
    vadimcn.vscode-lldb
    vadimcn.vscode-lldb
    vue.volar
    zhuangtongfa.material-theme
    zxh404.vscode-proto3
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "dart-code";
        publisher = "Dart-Code";
        version = "3.119.20250918";
        sha256 = "1ifzsissqbak95qb7k598zzx1mz3g8w6vafl3kjkd3x9myk3d5hk";
      }
      {
        name = "flutter";
        publisher = "Dart-Code";
        version = "3.119.20250901";
        sha256 = "03rpmn3rpxl6yfg7l9pv12nph9zy2mwpjnvjy8jq3kcd3scf8qip";
      }
      {
        name = "rasi";
        publisher = "dlasagno";
        version = "1.0.0";
        sha256 = "1yg9n2gsma5m0l76gch0m9mj2r0k2594cv4w90dx0w7px2aimbdk";
      }
      {
        name = "yuck";
        publisher = "eww-yuck";
        version = "0.0.3";
        sha256 = "1hxdxa13s1vlilw7fidr8vnl19c9wjazjvnvmqgl4fsswwny110c";
      }
      {
        name = "todo-tree";
        publisher = "Gruntfuggly";
        version = "0.0.226";
        sha256 = "0yrc9qbdk7zznd823bqs1g6n2i5xrda0f9a7349kknj9wp1mqgqn";
      }
      {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.112.2024050815";
        sha256 = "0b8j2iv7fd9nzmlfm1xh5bfhdffdinb98zcq1jvfizlckh308y3d";
      }
      {
        name = "remote-explorer";
        publisher = "ms-vscode";
        version = "0.5.2024031109";
        sha256 = "1r8wdlz7p0k4kzfcmqiizns043lhghf5v34sf0gays02x8x9xh5p";
      }
      {
        name = "material-icon-theme";
        publisher = "PKief";
        version = "5.2.0";
        sha256 = "0dkv6rnixnj4rwz9fb8hmn6m3mrgm80x3i07rxf477m9rgwp84iv";
      }
      {
        name = "autoimport";
        publisher = "steoates";
        version = "1.5.4";
        sha256 = "0rh5l4f4lcfanj30cd4xp84955ppnl7haglpl99vnd98kcj308pf";
      }
      {
        name = "code-spell-checker";
        publisher = "streetsidesoftware";
        version = "3.0.1";
        sha256 = "0i76gf7zr0j4dr02zmxwfphk6yy8rvlj9rzq3k8pvnlfzkmh9ri9";
      }
      {
        name = "code-spell-checker-polish";
        publisher = "streetsidesoftware";
        version = "2.1.2";
        sha256 = "0d905qig9dw73gk9z50ar1g914c5fcpyaqn8p22g2hxfl0sfhcfk";
      }
      {
        name = "tauri-vscode";
        publisher = "tauri-apps";
        version = "0.2.6";
        sha256 = "03nfyiac562kpndy90j7vc49njmf81rhdyhjk9bxz0llx4ap3lrv";
      }
      {
        name = "vscodeintellicode";
        publisher = "VisualStudioExptTeam";
        version = "1.3.1";
        sha256 = "0zl3hm5i769aqi16g236mpadlkxsh09872b5hc7j9js2xm051hv4";
      }
      {
        name = "intellicode-api-usage-examples";
        publisher = "VisualStudioExptTeam";
        version = "0.2.8";
        sha256 = "1l1wjzbl5jjniyiqzlj23i3sl2xy5jsx97wsj3sbb6py0pfi4w39";
      }
    ])
    ++ [
      continue
    ];

  vscode-with-extensions = pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };

in {
  config = { environment.systemPackages = [ vscode-with-extensions ]; };
}
