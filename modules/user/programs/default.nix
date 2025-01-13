{
  lib,
  config,
  pkgs,
  nvim,
  flakeDir,
  ...
}:
{
  imports = [
    ./gui
    ./zsh

    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./jq.nix
    ./lazygit.nix
    ./ledger.nix
    ./less.nix
    ./neomutt.nix
    ./syncthing.nix
    ./tmux.nix
    ./zoxide.nix
  ];

  home.packages =
    let
      essentials = (import ./essentials.nix pkgs);
    in
    with pkgs;
    [
      _1password-cli
      eslint_d
      prettierd
      sops

      (lib.mkIf config.user.nixvim.enable nvim)
    ]
    ++ essentials;

  programs =
    let
      shellAliases = {
        cat = "bat";
        ls = "eza";
        tree = "eza --tree";
        diff = "delta";
        gg = "lazygit";

        branch =
          # sh
          "git branch --show-current";

        branchhelp =
          # sh
          ''
            git branch --list | rg -v '^\s+?\*|\+' | fzf | awk '{$1=$1};1'
          '';

        nvim-next =
          # sh
          "nix run ${flakeDir}#nvim";
      };
    in
    {
      ssh.enable = true;
      home-manager.enable = true;
      bash.shellAliases = shellAliases;
      zsh.shellAliases = shellAliases;
    };
}
