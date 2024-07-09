{
  inputs,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    shortcut = "Space";
    terminal = "$TERM"; # TODO: This needs to be set to an environment var or something for correct behavior in tty
    # terminal = "xterm-256color"; # TODO: This needs to be set to an environment var or something for correct behavior in tty
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = better-mouse-mode;
        extraConfig = "set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'";
      }
      {
        plugin = power-theme;
        extraConfig = "set -g @tmux_power_theme 'default'";
      }
    ];

    extraConfig =
      /*
      tmux
      */
      ''
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        set -ag terminal-overrides ",$TERM:Tc"
      '';
  };
}