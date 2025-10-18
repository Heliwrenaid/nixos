{ pkgs, inputs, settings, ... }:

{
  imports = [
    (import ./wm/${settings.wm}/default.nix { inherit inputs pkgs settings; })
  ];

  home.username = "${settings.user}";
  home.homeDirectory = "/home/${settings.user}";
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
