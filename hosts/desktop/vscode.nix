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
            version = "1.3.28";
            sha256 = "sha256-Yx82pjTOJIYYtFk1q6M+0fdKYqIW3OfUeQzB9tos9/g=";
            arch = "linux-x64";
          };
          # Patch obtained from: https://github.com/continuedev/continue/issues/821
          nativeBuildInputs = [pkgs.autoPatchelfHook];
          buildInputs = [pkgs.stdenv.cc.cc.lib];
        };
  volar =
        pkgs.vscode-utils.buildVscodeMarketplaceExtension
        {
          mktplcRef = {
            name = "volar";
            publisher = "Vue";
            version = "2.2.12";
            sha256 = "sha256-cQxDoKDfzifcGTkhS8rC+JUQofbxMfXmkJF1CwiU1nc=";
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
    tamasfe.even-better-toml
    tomoki1207.pdf
    twxs.cmake
    usernamehw.errorlens
    vadimcn.vscode-lldb
    zhuangtongfa.material-theme
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "dart-code";
        publisher = "Dart-Code";
        version = "3.127.20251229";
        sha256 = "0f1kbnibc2zskf2abvqpqix94qps7dg7jg3bkcr4pqk3d6k4h19y";
      }
      {
        name = "flutter";
        publisher = "Dart-Code";
        version = "3.127.20251229";
        sha256 = "1fwpi9kz9j49ds3gw2pilnjpf75kc45k9k03ly752msd4nmxi709";
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
        name = "remote-explorer";
        publisher = "ms-vscode";
        version = "0.6.2025081809";
        sha256 = "10rsnl5yk08mhcwg5j7s2xsawd7v2ilcgg2rm9v904v3nd2qi8xv";
      }
      {
        name = "material-icon-theme";
        publisher = "PKief";
        version = "5.30.0";
        sha256 = "1n6wm3vf5v3bgx7y6d3v8xd445rdkxfkpp445y8kwas16rm6mmr9";
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
        version = "4.4.0";
        sha256 = "0apnryj2jpbd1z6015xkj7f492cmk27gilmvi930nnkf2wgsdmp2";
      }
      {
        name = "code-spell-checker-polish";
        publisher = "streetsidesoftware";
        version = "2.1.4";
        sha256 = "0mms6mr64jwv7s8wivhnxl370nmq6bxpfpm9s9z489b6dk20h5na";
      }
      {
        name = "tauri-vscode";
        publisher = "tauri-apps";
        version = "0.2.9";
        sha256 = "0l3si78il7ja6621991nljjvvywwkwfnnix9jz5s8y0il2cfq9y9";
      }
      {
        name = "tailwind-documentation";
        publisher = "alfredbirk";
        version = "0.1.16";
        sha256 = "03yyranny5pjdnk0m3hh4qwi80flcz1gy7bf8ml76lc9f1d7ybl4";
      }
      {
        name = "vscode-buf";
        publisher = "bufbuild";
        version = "0.8.1";
        sha256 = "0zz3basx6gwb06gdc66h0cnq612l3vlziqaaxcz641krpjzbb4d4";
      }
      {
        name = "crates-io";
        publisher = "BarbossHack";
        version = "0.7.6";
        sha256 = "0ggmrsdx100fdbf1lmz13hmw743yr4b5rqrm7sjzr9z5mgzb0r3i";
      }
    ])
    ++ [
      continue
      volar
    ];

  vscode-with-extensions = pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };

in {
  config = { environment.systemPackages = [ vscode-with-extensions ]; };
}
