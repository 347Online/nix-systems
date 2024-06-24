{
  description = "Katie's Nix Systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nur.url = "github:nix-community/NUR";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-config = {
      url = "github:347Online/nvim-config-kt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    nix-darwin,
    home-manager,
    fenix,
    nix-homebrew,
    nix-vscode-extensions,
    nixvim-config,
    zjstatus,
    ...
  }: let
    # overlays = with inputs; [
    #   # ...
    #   (final: prev: {
    #     zjstatus = zjstatus.packages.${prev.system}.default;
    #   })
    # ];
    # Magic value will need to be adapted to run flake on non-darwin or non-ARM systems
    pkgs' = import nixpkgs {};
    system = "aarch64-darwin";
    username = "katie";
    homeDirectory =
      if pkgs'.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    specialArgs = {
      inherit inputs username homeDirectory;
    };
    extraSpecialArgs =
      specialArgs
      // {
        inherit fenix;
        vscode-extensions = nix-vscode-extensions.extensions.${system};
      };

    baseModulesHomeManager = [
      ./modules/home
      {home.packages = [nixvim-config.packages.${system}.default];}
    ];

    baseModulesDarwin = [
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      ./modules/darwin
      {
        environment.pathsToLink = ["/share/zsh"];
        home-manager = {
          inherit extraSpecialArgs;
          users.${username}.imports = baseModulesHomeManager;
          backupFileExtension = "bakk";
        };
      }
    ];

    mkDarwin = module:
      nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = baseModulesDarwin ++ [module];
      };
  in {
    darwinConfigurations."Athena" = mkDarwin (import ./hosts/Athena.nix);
    darwinConfigurations."Alice" = mkDarwin (import ./hosts/Alice.nix);
  };
}
