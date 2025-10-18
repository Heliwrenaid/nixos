{ pkgs, ... }:
let
  scripts-brightness = pkgs.writeShellScriptBin "scripts-brightness" ''
    ${./brightness.sh} $@
  '';
  scripts-bluetooth = pkgs.writeShellScriptBin "scripts-bluetooth" ''
    ${./bluetooth.sh} $@
  '';
  scripts-change-active-workspace = pkgs.writeShellScriptBin "scripts-change-active-workspace" ''
    ${./change-active-workspace.sh} $@
  '';
  scripts-get-workspaces = pkgs.writeShellScriptBin "scripts-get-workspaces" ''
    ${./get-workspaces.sh} $@
  '';
  scripts-power-profile = pkgs.writeShellScriptBin "scripts-power-profile" ''
    ${./power-profile.sh} $@
  '';
  scripts-screenshot = pkgs.writeShellScriptBin "scripts-screenshot" ''
    ${./screenshot.sh} $@
  '';
  scripts-search-icon = pkgs.writeShellScriptBin "scripts-search-icon" ''
    ${./search-icon.sh} $@
  '';
  scripts-swayidle = pkgs.writeShellScriptBin "scripts-swayidle" ''
    ${./swayidle.sh} $@
  '';
  scripts-swaylock = pkgs.writeShellScriptBin "scripts-swaylock" ''
    ${./swaylock.sh} $@
  '';
  scripts-swww-randomize = pkgs.writeShellScriptBin "scripts-swww-randomize" ''
    ${./swww-randomize.sh} $@
  '';
  scripts-volume = pkgs.writeShellScriptBin "scripts-volume" ''
    ${./volume.sh} $@
  '';
  scripts-widget = pkgs.writeShellScriptBin "scripts-widget" ''
    ${./widget.sh} $@
  '';
  scripts-wifi = pkgs.writeShellScriptBin "scripts-wifi" ''
    ${./wifi.sh} $@
  '';
in {
  home.packages = [
    scripts-brightness
    scripts-bluetooth
    scripts-change-active-workspace
    scripts-get-workspaces
    scripts-power-profile
    scripts-screenshot
    scripts-search-icon
    scripts-swayidle
    scripts-swaylock
    scripts-swww-randomize
    scripts-volume
    scripts-widget
    scripts-wifi
  ];
}
