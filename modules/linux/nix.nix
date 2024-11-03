{pkgs, ...}: {
  nix = {
    package = pkgs.nix;
    settings = {
      download-buffer-size = 524288000;
      experimental-features = "nix-command flakes";
      trusted-users = ["katie"];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
  };
}
