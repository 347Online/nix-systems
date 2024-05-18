{
  description = "Katie's Nix Systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    fenix = {
      url = "github:nix-community/fenix";
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

    nixvim-module = {
      url = "github:nix-community/nixvim";
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

    nix-minecraft = {
      url = "github:12Boti/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    fenix,
    nix-darwin,
    home-manager,
    nixpkgs,
    nixvim-module,
    nix-homebrew,
    nix-vscode-extensions,
    ...
  }: let
    system = "aarch64-darwin"; # TODO: Consider possibility of linux
    username = "katie";
    homeDirectory = "/Users/${username}"; # TODO: Consider possibility of linux
    specialArgs = {inherit inputs system username homeDirectory;};
    extraSpecialArgs =
      specialArgs
      // {
        vscode-extensions = nix-vscode-extensions.extensions.${system};
        nixvim = nixvim-module.homeManagerModules.nixvim;
        inherit fenix;
      };
    baseModulesDarwin = [
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      ./modules/darwin
      {
        environment.pathsToLink = ["/share/zsh"];
        home-manager = {
          inherit extraSpecialArgs;
          users.${username} = import ./modules/home;
          backupFileExtension = "bakk";
        };
      }
    ];
  in {
    # TODO: Move into hosts directory
    darwinConfigurations."Athena" = nix-darwin.lib.darwinSystem {
      modules =
        baseModulesDarwin
        ++ [
          {
            home-manager.users.${username} = {
              lang.rust.toolchain = "beta";
              gaming.enable = true;
            };
          }
        ];
      inherit specialArgs;
    };

    darwinConfigurations."Alice" = nix-darwin.lib.darwinSystem {
      modules =
        baseModulesDarwin
        ++ [
          {
            home-manager.users.${username} = {
              lang.java.enable = true;
            };
          }
        ];
      inherit specialArgs;
    };
  };
}
