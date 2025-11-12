{ pkgs, settings, ... }:

let
  profile = settings.hyprland.rices.ewwBased;
  swwProps = profile.sww;
  swaylockProps = profile.swaylock;

  run-swaylock = pkgs.writeShellScriptBin "run-swaylock" ''
    ${./scripts/swaylock.sh} "${swaylockProps.wallpaper}"
  '';
in
{
  settings = {
    "$mainMod" = "SUPER";

    bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive "
        "$mainMod, M, exit "
        "$mainMod, V, togglefloating "

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Rofi
        "$mainMod, A, exec, rofi -show drun"
        "$mainMod, S, exec, rofi -show filebrowser"
        "$mainMod, D, exec, rofi -show run"

        # Apps
        "$mainMod, F, exec, firefox"
        "$mainMod, E, exec, nemo"

        # Screenlock
        "$mainMod, L, exec, scripts-swaylock ${swaylockProps.wallpaper}"

        # Media keys
        ",XF86AudioMute, exec, scripts-volume toggle"
        ",XF86AudioLowerVolume, exec, scripts-volume down 10"
        ",XF86AudioRaiseVolume, exec, scripts-volume up 10"

        # Other
        ",Print, exec, scripts-screenshot"
        "$mainMod, I, exec, scripts-swww-randomize ${swwProps.wallpaperDir} change &> /dev/null"
        # ",XF86MonBrightnessUp, exec, scripts-brightness up 10"
        # ",XF86MonBrightnessDown, exec, scripts-brightness down 10"
    ];

    bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
    ];
    exec-once = [
        "source ~/.bashrc"
        "lxqt-policykit-agent"
        "scripts-swayidle ${run-swaylock}/bin/run-swaylock ${toString swaylockProps.lockTimeout} ${toString swaylockProps.screenOffInterval}"
        "swww init"
        "eww daemon"
        "eww open mybar"
        "dunst"
        "copyq --start-server"
        "scripts-swww-randomize ${swwProps.wallpaperDir} &> /dev/null &"
        "spotifyd"
    ];

    monitor = [
      "DP-3, 1920x1080@120, 0x0, 1"
      "HDMI-A-1, 1920x1080@60, 1920x0, 1"
    ];

    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "XDG_SESSION_DESKTOP,Hyprland"
      "QT_QPA_PLATFORM,wayland"  
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      "XCURSOR_SIZE,24"
      "XCURSOR_THEME,Bibata-Modern-Classic"
      "NIXOS_OZONE_WL,1"
      "WLR_NO_HARDWARE_CURSORS,1" 
    ];

    general = {
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      "col.active_border" = "rgba(5631ecdd) rgba(6a0e45ee) 30deg";
      "col.inactive_border" = "rgba(595959aa)";
      layout = "dwindle";
    };

    decoration = {
      rounding = 10;
      blur = {
        enabled = true;  
        size = 3;
        passes = 1;
        new_optimizations = true;
      };
      shadow = {
        enabled = true;
        range = 40;
        render_power = 3;
      };
    };
    
    input = {
      kb_layout = "pl";
      kb_options = "grp:alt_shift_toggle";
      follow_mouse = 1;
    };

    animations = {
      enabled = true;
      bezier = [
        "myBezier, 0.05, 0.9, 0.1, 1.05"
      ];
      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };
    
    misc = {
      disable_hyprland_logo = true;
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true ;
    };
  };

  extraPackages = with pkgs; [
    dunst
    fira-code
    libnotify # for dunst
    grim
    slurp
    swayidle
    swaylock
    python3
    socat
    jq
    alsa-utils
    pipewire
    wireplumber
    networkmanager
    rofi-wayland
    eww
    swww
    copyq
    networkmanagerapplet
    brightnessctl
    coreutils-full
    bc
    pavucontrol
  ];

  imports = [
    ./scripts
    ./dunst
    ./eww
    ./kitty
    ./rofi
    ({ ... }: {
      fonts.fontconfig.enable = true;

      gtk = {
        enable = true;
        theme = {
          name = "Layan-Dark";
          package = pkgs.layan-gtk-theme;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        font = {
          name = "Sans";
          size = 12;
        };
      };

      # Lockscreen
      programs.swaylock.enable = true;

      home.pointerCursor = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        gtk.enable = true;
        x11.enable = true;
        size = 24;
      };
    })
  ];
}
