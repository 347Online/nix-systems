{
  pkgs,
  username,
  homeDirectory,
  ...
}: {
  imports = [
    ./dev
    ./games
  ];

  programs.home-manager.enable = true;

  home = {
    inherit
      username
      homeDirectory
      ;

    packages = with pkgs; [
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})

      alejandra
      bat
      cargo
      eza
      nodejs
      python3
      _1password-gui
      _1password
      # maestral
    ];
  };

  news.display = "silent";

  # DO NOT EDIT BELOW
  home.stateVersion = "23.11";
}
