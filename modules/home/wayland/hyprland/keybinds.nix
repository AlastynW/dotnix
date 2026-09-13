# Raccourcis clavier bruts (extraConfig, syntaxe hyprlang). `$mainMod` ci-dessous
# est du texte littéral interprété côté Hyprland (variable définie dans
# settings.nix via `"$mainMod" = mainMod;`), pas de l'interpolation nix.
{
  pkgs,
  lib,
  ...
}:
let
  # TODO: Rewrite this file to use nix language now that hyprland HM module update is merged.
  exe = import ./exe-paths.nix { inherit pkgs lib; };

  applicationsShortcuts =
    let
      term = exe.kitty;
      dmenu = "${exe.rofi} -modi drun -show drun -show-icons";
      swaylock = "${exe.swaylock-effects} -S";
      screenshot = "${exe.grim} -g \"$(${exe.slurp})\" - | ${exe.wl-copy}";
      alsa = "${exe.amixer} -q sset Master";
    in
    ''
      bind = $mainMod, Return, exec, ${term}
      bind = $mainMod, D, exec, ${dmenu}
      bind = $mainMod, L, exec, ${swaylock}
      bind = , PRINT, exec, ${screenshot}
      bind = $mainMod SHIFT, S, exec, ${screenshot}

      binde = , XF86MonBrightnessDown, exec, ${exe.brightnessctl} set 5%-
      binde = , XF86MonBrightnessUp, exec, ${exe.brightnessctl} set 5%+
      binde = , Scroll_Lock, exec, ${exe.brightnessctl} set 5%-
      binde = , Pause, exec, ${exe.brightnessctl} set 5%+

      binde = , XF86AudioRaiseVolume, exec, ${alsa} 1%+
      binde = , XF86AudioLowerVolume, exec, ${alsa} 1%-
      bindl = , XF86AudioMute, exec, ${alsa} toggle

      bindl = , XF86AudioPlay, exec, ${exe.playerctl} play-pause
      bindl = , XF86AudioPause, exec, ${exe.playerctl} play-pause
      bindl = , XF86AudioNext, exec, ${exe.playerctl} next
      bindl = , XF86AudioPrev, exec, ${exe.playerctl} previous

    '';

  workspaceControl = ''
    # workspaces
    # binds mainMod + [shift +] {1..10} to [move to] ws {1..10}
    ${builtins.concatStringsSep "\n" (
      builtins.genList (
        x:
        let
          ws =
            let
              c = (x + 1) / 10;
            in
            builtins.toString (x + 1 - (c * 10));
        in
        ''
          bind = $mainMod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
        ''
      ) 10
    )}

    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1
  '';

  compositorControls = ''
    bind = $mainMod SHIFT, Q, killactive
    bind = $mainMod SHIFT, E, exec, poweroff

    bind = $mainMod, F, fullscreen
    bind = $mainMod, Space, togglefloating

    bindm = $mainMod, mouse:272, hy3:movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # hy3 groups
    bind = $mainMod, H, hy3:makegroup, h
    bind = $mainMod, V, hy3:makegroup, v

    # move focus
    bind = $mainMod, left, hy3:movefocus, l
    bind = $mainMod, right, hy3:movefocus, r
    bind = $mainMod, up, hy3:movefocus, u
    bind = $mainMod, down, hy3:movefocus, d

    # move window
    binde = $mainMod SHIFT, left, hy3:movewindow, l
    binde = $mainMod SHIFT, right, hy3:movewindow, r
    binde = $mainMod SHIFT, up, hy3:movewindow, u
    binde = $mainMod SHIFT, down, hy3:movewindow, d
    # When floating
    binde = $mainMod SHIFT, left, moveactive, -30 0
    binde = $mainMod SHIFT, right, moveactive, 30 0
    binde = $mainMod SHIFT, up, moveactive, 0 -30
    binde = $mainMod SHIFT, down, moveactive, 0 30

    # window resize
    bind = $mainMod, R, submap, resize

    submap = resize
    binde = , right, resizeactive, 10 0
    binde = , left, resizeactive, -10 0
    binde = , up, resizeactive, 0 -10
    binde = , down, resizeactive, 0 10
    bind = , escape, submap, reset
    submap = reset
  '';

  general = ''
    monitor=eDP-1, preferred, auto, 1
    monitor=, preferred, auto, 1

    input {
      kb_layout = us
      kb_variant = intl
      follow_mouse = 1 # Cursor movement will always change focus to the window under the cursor.
    }

    # idle inhibit while watching videos
    windowrule = idle_inhibit focus, match:class ^(mpv|.+exe)$
    windowrule = idle_inhibit focus, match:class ^(brave)$, match:title ^(.*YouTube.*)$
    windowrule = idle_inhibit fullscreen, match:class ^(brave)$
  '';
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    ${workspaceControl}
    ${compositorControls}
    ${applicationsShortcuts}
    ${general}
  '';
}
