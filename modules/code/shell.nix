{
  config,
  lib,
  pkgs,
  ...
}: let
  shellAliases = with pkgs; {
    "bash" = "${bash}/bin/bash";
    "branch" = "${git}/bin/git branch --show-current";
    "cat" = "${bat}/bin/bat";
    "code" = "${vscodium}/bin/codium";
    "git" = "${git}/bin/git";
    "python3" = "${python3}/bin/python";
    "vi" = "nvim";
    "vim" = "nvim";
  };

  shellIntegrations = {
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
in {
  options = {
    code.shell.enable = lib.mkEnableOption "shell setup";
  };

  config = lib.mkIf config.code.shell.enable {
    home.packages = with pkgs; [
      bat
      eza
    ];

    programs = {
      kitty = {
        enable = true;
        font.name = "JetBrainsMono Nerd Font";
        font.size = 12;
        settings = {
          confirm_os_window_close = 0;
        };
        darwinLaunchOptions = [
          "--single-instance"
        ];

        shellIntegration = shellIntegrations;
      };

      bash.shellAliases = shellAliases;

      fish = {
        enable = true;
        plugins = [
          # Experimental
          {
            name = "nix.fish";
            src = pkgs.fetchFromGitHub {
              owner = "kidonng";
              repo = "nix.fish";
              rev = "master";
              sha256 = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
            };
          }
        ];
        inherit shellAliases;
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        shellAliases = shellAliases // {"ls" = "${pkgs.eza}/bin/eza";};
      };

      fzf.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      zoxide =
        shellIntegrations
        // {
          enable = true;
          options = [
            "--cmd"
            "cd"
          ];
        };
    };
  };
}
