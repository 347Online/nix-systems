{
  lib,
  config,
  username,
  ...
}:
lib.mkIf config.darwin.homebrew.enable {
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # TODO: Uncomment after homebrew update
      # cleanup = "uninstall";
    };

    masApps = {
      "1Password for Safari" = 1569813296;
      "Broadcasts" = 1469995354;
      "Fantastical" = 975937182;
      "GoodLinks" = 1474335294;
      "Magic Lasso" = 1198047227;
      "Noir" = 1592917505;
      "Numbers" = 409203825;
      # "Overcast" = 888422857; # Currently broken
      "Pages" = 409201541;
      "StopTheMadness Pro" = 6471380298;
    };

    casks = [
      "1password"
      "raycast"
      "setapp"
      "scroll-reverser"
      "logi-options-plus"
      "obsidian"
    ];
  };

  environment.variables = {
    HOMEBREW_NO_ENV_HINTS = "1";
    HOMEBREW_PREFIX = "/opt/homebrew";
    HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
    HOMEBREW_REPOSITORY = "/opt/homebrew/Library/.homebrew-is-managed-by-nix";
    PATH = "/opt/homebrew/bin:/opt/homebrew/sbin\${PATH+:$PATH}";
    MANPATH = "/opt/homebrew/share/man\${MANPATH+:$MANPATH}:";
    INFOPATH = "/opt/homebrew/share/info:\${INFOPATH:-}";
  };
}
