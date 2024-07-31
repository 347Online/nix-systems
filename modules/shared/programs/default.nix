{
  lib,
  config,
  pkgs,
  util,
  nvim,
  isDarwin,
  ...
}: {
  imports = [
    ./codium
    ./firefox
    ./zsh

    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./lazygit.nix
    ./ledger.nix
    ./neomutt.nix
    ./tmux.nix
    ./wezterm.nix
    ./zoxide.nix
  ];

  options = {
    nvim-setup.enable = lib.mkEnableOption "neovim setup";
  };

  config = {
    nvim-setup.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      _1password
      alejandra
      bat
      eza
      fd
      mise
      nil
      prettierd
      ripgrep
      vim

      (lib.mkIf config.nvim-setup.enable nvim)
    ];

    programs = {
      ssh = {
        enable = true;
        # TODO: Consider disabling if headless
        extraConfig =
          util.mkIfElse isDarwin ''IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'' "IdentityAgent ~/.1password/agent.sock";
      };
      home-manager.enable = true;
      bash.shellAliases = util.mkShellAliases pkgs;
    };
  };
}
