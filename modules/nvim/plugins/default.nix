{pkgs, ...}: {
  imports = [
    ./actions-preview.nix
    ./cokeline.nix
    ./completion.nix
    ./delimitMate.nix
    ./formatting.nix
    ./git.nix
    ./lsp.nix
    ./neo-tree.nix
    ./precognition.nix
    ./telescope.nix
  ];

  plugins = {
    luasnip.enable = true;
    lualine.enable = true;
    indent-blankline.enable = true;
    nix.enable = true;
    treesitter = {
      enable = true;
    };
  };
}
