{
  pkgs,
  lib,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        "${pkgs.alacritty-theme}/iterm.toml"
      ];
      window.option_as_alt = lib.mkIf isDarwin "Both";
      env.term = "xterm-256color";
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size =
          if isDarwin
          then 13
          else 6;
      };
    };
  };
}
