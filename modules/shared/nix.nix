{
  nur,
  inputs,
  ...
}: {
  nix = {
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixos-hardware.flake = inputs.nixos-hardware;
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      packageOverrides = pkgs: {
        inherit nur;
      };
    };
  };
}
