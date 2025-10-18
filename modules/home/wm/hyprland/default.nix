{ inputs, pkgs, settings, ... }:

let
  rice = import ./rices/${settings.hyprland.currentRice} { inherit pkgs settings; };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    systemd.variables = ["--all"];
    settings = rice.settings;
  };

  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5ct
    qt6ct
    kitty
  ] ++ (rice.extraPackages or []);

  # Let the rice define its own theming
  imports = rice.imports or [];

}
