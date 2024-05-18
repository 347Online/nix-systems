{
  pkgs,
  lib,
  username,
  homeDirectory,
  nixvim,
  ...
}: {
  # TODO: Break up into sub-modules

  imports = [
    nixvim

    # ./dotfiles
    ./nix.nix

    ../code
    ../gaming
  ];

  code.enable = lib.mkDefault true;
  gaming.enable = lib.mkDefault false;

  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory;

    file = let
      listFilesRecursive = dir: acc:
        lib.flatten (lib.mapAttrsToList
          (k: v:
            if v == "regular"
            then "${acc}${k}"
            else listFilesRecursive dir "${acc}${k}/")
          (builtins.readDir "${dir}/${acc}"));

      toHomeFiles = dir:
        builtins.listToAttrs
        (map (x: {
          name = x;
          value = {source = "${dir}/${x}";};
        }) (listFilesRecursive dir ""));
    in
      toHomeFiles ../home/dotfiles;

    packages = with pkgs; [
      # Essentials
      (nerdfonts.override {fonts = ["JetBrainsMono"];})

      _1password
      _1password-gui

      obsidian

      maestral # Untested on Linux
    ];
  };

  news.display = "silent";

  # DO NOT EDIT BELOW
  home.stateVersion = "23.11";
}
