{
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}: let
  listFilesRecursive = dir: acc:
    lib.flatten (lib.mapAttrsToList
      (k: v:
        if v == "regular"
        then "${acc}${k}"
        else listFilesRecursive dir "${acc}${k}/")
      (builtins.readDir "${dir}/${acc}"));

  toHomeFiles = dir:
    builtins.listToAttrs
    (map (name: {
      inherit name;
      value = {source = "${dir}/${name}";};
    }) (listFilesRecursive dir ""));
in {
  imports = [
    ./programs
    ./nix.nix
    ./rust.nix
  ];

  home = {
    inherit username homeDirectory;

    sessionVariables.EDITOR = "nvim";

    file = toHomeFiles ./dotfiles;

    activation = {
      miseInstall = lib.hm.dag.entryAfter ["installPackages"] ''
        # rtx has been renamed to mise
        ${pkgs.rtx}/bin/mise install
      '';
    };

    packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})

      bat
      eza
      ripgrep
      rtx

      _1password
      _1password-gui

      obsidian
    ];
  };

  news.display = "silent";

  # DO NOT EDIT BELOW
  home.stateVersion = "23.11";
}
