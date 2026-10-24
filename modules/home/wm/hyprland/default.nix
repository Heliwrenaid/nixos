{ inputs, pkgs, settings, ... }:

let
  rice = import ./rices/${settings.hyprland.currentRice} { inherit pkgs settings; };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.variables = ["--all"];
    configType = "hyprlang";
    settings = rice.settings;
  };

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    kitty
  ] ++ (rice.extraPackages or []);

  # Let the rice define its own theming
  imports = rice.imports or [];

}
