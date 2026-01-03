{ config, pkgs, inputs, ... }:

let
  settings = import ../../modules/settings.nix;
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/a2e82f6a4efdbf8fc1db8bbded37da5aa1e3b60a.tar.gz";
    sha256 = "0n9m3a0cb85p4w1idzdz56j21q8q1ma1hplnzhr77pg1ihi4fc3q";
  }) {
    system = builtins.currentSystem or "x86_64-linux";
    config = config.nixpkgs.config;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ./vscode.nix
  ];

  # ----------------- NixOS ----------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";

  # ----------------- Bootloader -----------------

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  # ----------------- Networking -----------------

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.extraHosts =
  ''
    127.0.0.1 kafka
  '';

  # ----------------- Language -------------------

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # ----------------- User -----------------------

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${settings.user} = {
    isNormalUser = true;
    description = "${settings.user}";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nix.settings.trusted-users = [ "root" "${settings.user}" ];

  # ----------------- Services -------------------

  # X11 config
  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" ];
  };

  # Display Manager config
  services.displayManager = {
    sddm.enable = true;
    sessionPackages = if settings.wm == "hyprland" then [
      inputs.hyprland.packages.${pkgs.system}.default
    ] else [ ];
    defaultSession = if settings.wm == "hyprland" then "hyprland" else "";
  };

  # Docker
  virtualisation.docker.enable = true;

  # Ollama with AMD graphics card acceleration
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100";
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  hardware.bluetooth.settings = {
      General = {
      Enable = "Source,Sink,Media,Socket";
      };
  };

  # XDG portals
  # Debugging:
  # systemctl --user status xdg-desktop-portal-hyprland.service
  # systemctl --user status xdg-desktop-portal-gtk.service 
  # systemctl --user status xdg-desktop-portal.service 
  xdg.portal.enable = true;
  xdg.portal.extraPortals =
    [ pkgs.xdg-desktop-portal-gtk ] ++
    (if settings.wm == "hyprland" then [
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ] else []);

  # xdg-desktop-portal 1.17 reworked how portal implementations are loaded, you
  # should either set `xdg.portal.config` or `xdg.portal.configPackages`
  # to specify which portal backend to use for the requested interface.
  #
  # https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in
  #
  # If you simply want to keep the behaviour in < 1.17, which uses the first
  # portal implementation found in lexicographical order, use the following:
  #
  # xdg.portal.config.common.default = "*";
  xdg.portal.config.common = {
    default = [
      "gtk"
    ];
    hyprland = [
      "hyprland"
      "gtk"
    ];
  };

  # Others
  services.power-profiles-daemon.enable = true;
  services.udisks2.enable = true;
  programs.nix-ld.enable = true;
  programs.direnv.enable = true;
  # https://discourse.nixos.org/t/error-gdbus-error-org-freedesktop-dbus-error-serviceunknown-the-name-ca-desrt-dconf-was-not-provided-by-any-service-files/29111
  programs.dconf.enable = true;

  # Mullvad
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn; # GUI

  # ----------------- Packages -------------------

  environment.systemPackages = with pkgs; [
    # stable channel
    amberol
    bat
    chromium
    cmake
    config.boot.kernelPackages.perf
    evince
    file
    firefox
    gcc
    git
    gnumake
    home-manager
    hunspell
    hunspellDicts.en_US
    hunspellDicts.pl_PL
    killall
    libreoffice
    lxqt.lxqt-policykit
    nemo-fileroller
    nemo-with-extensions
    nix-index
    nnn
    obs-studio
    p7zip
    patchelf
    pciutils
    photoqt
    ripgrep
    telegram-desktop
    thunderbird
    vim
    vlc
    vscode-with-extensions
    wget
    zlib
    radeontop

    # unstable channel
    unstable.joplin-desktop
  ];

  # ----------------- Home Manger ----------------

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${settings.user} = import ../../modules/home/default.nix {
    inherit pkgs inputs settings;
  };

  # ----------------- Others ---------------------

  time.timeZone = "Europe/Warsaw";
  boot.supportedFilesystems = [ "ntfs" ];
  # https://github.com/hyprwm/Hyprland/issues/2727
  security.pam.services.swaylock = if settings.wm == "hyprland" then { } else { };


}
