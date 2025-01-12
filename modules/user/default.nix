{
  username,
  homeDirectory,
  util,
  config,
  lib,
  ...
}:
{
  imports = [
    ./games
    ./programs

    ./nix.nix
    ./options.nix
    ./scripts.nix
  ];

  config = lib.mkMerge [
    {
      home = {
        inherit username homeDirectory;

        sessionVariables.EDITOR = "nvim";

        file = util.toHomeFiles ./dotfiles;
      };

      news.display = "silent";

      # DO NOT EDIT BELOW
      home.stateVersion = "23.11";
    }

    (lib.mkIf config.user.gui.enable {
      user.codium.enable = true;
    })
  ];
}
