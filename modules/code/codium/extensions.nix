{
  config,
  pkgs,
  vscode-extensions,
  ...
}: {
  programs.vscode.extensions = with vscode-extensions;
  with pkgs.vscode-extensions;
    [
      # Essentials
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      eamodio.gitlens
      mkhl.direnv
      ms-vsliveshare.vsliveshare

      # Formatting
      foxundermoon.shell-format
      bmalehorn.vscode-fish
      tamasfe.even-better-toml
      mechatroner.rainbow-csv
      open-vsx.yoavbls.pretty-ts-errors

      # Visuals
      pkief.material-icon-theme
      oderwat.indent-rainbow
      bradlc.vscode-tailwindcss

      # Utilities
      ritwickdey.liveserver
      vscode-marketplace.cweijan.vscode-database-client2
      ms-vscode.hexeditor
      asvetliakov.vscode-neovim
    ]
    ++ config.code.codium.extraExtensions;
}
