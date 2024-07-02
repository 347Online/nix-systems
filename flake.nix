{
  description = "Katie's Nix Systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";

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

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    precognition-nvim = {
      url = "github:tris203/precognition.nvim";
      flake = false;
    };

    apple-silicon-support = {url = "github:tpwrules/nixos-apple-silicon";};
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nur,
    nix-darwin,
    home-manager,
    fenix,
    nix-homebrew,
    nix-vscode-extensions,
    nil,
    neovim-nightly-overlay,
    nixvim,
    ...
  }: let
    linuxSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    darwinSystems = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    supportedSystems = linuxSystems ++ darwinSystems;

    forSystem = system: f:
      f rec {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          overlays = self.overlays.default;
        };
      };

    forSystems = f: systems:
      nixpkgs.lib.genAttrs systems (system: (forSystem system f));

    forAllSystems = f:
      forSystems f
      supportedSystems;

    util = import ./modules/util.nix;

    system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    username = "katie";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";

    nvim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
      pkgs = pkgs.extend (final: prev: {
        vimPlugins = prev.vimPlugins.extend (final': prev': {
          precognition-nvim = prev.vimUtils.buildVimPlugin {
            pname = "precognition-nvim";
            src = inputs.precognition-nvim;
            version = inputs.precognition-nvim.shortRev;
          };
        });
      });
      module = (import ./modules/nvim) // {package = neovim-nightly-overlay.packages.${system}.default;};
    };

    specialArgs = {
      inherit inputs username homeDirectory util system nvim;
    };
    extraSpecialArgs =
      specialArgs
      // {
        inherit fenix;
        vscode-extensions = nix-vscode-extensions.extensions.${system};
      };

    baseModulesHomeManager = [
      nixvim.homeManagerModules.nixvim
      ./modules/home
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
    darwinConfigurations."Athena" = mkDarwin (import ./modules/hosts/Athena.nix);
    darwinConfigurations."Alice" = mkDarwin (import ./modules/hosts/Alice.nix);

    nixosConfigurations."Arctic" = nixpkgs.lib.nixosSystem {
      inherit specialArgs;

      modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            inherit extraSpecialArgs;
            users.${username}.imports =
              baseModulesHomeManager
              ++ [
                ./modules/linux
              ];
            backupFileExtension = "bakk";
          };
        }
        ./modules/hosts/Arctic
      ];
    };

    nvim = nvim;
  };
}
