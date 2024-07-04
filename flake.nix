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
      inputs.nix-darwin.follows = "nix-darwin";
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
    username = "katie";
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
          # overlays = self.overlays.default;
        };
      };

    forSystems = f: systems:
      nixpkgs.lib.genAttrs systems (system: (forSystem system f));

    forAllSystems = f:
      forSystems f
      supportedSystems;

    util = import ./modules/util.nix inputs;

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        # overlays = [fenix.overlays.default];
      };

    mkNvim = pkgs: let
      system = pkgs.system;
    in
      inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
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

    mkSpecialArgs = pkgs: let
      system = pkgs.system;
    in {
      inherit inputs username util system;
      homeDirectory = util.mkHomeDirectory pkgs username;
      nvim = mkNvim pkgs;
    };

    mkExtraSpecialArgs = pkgs: let
      system = pkgs.system;
    in
      (mkSpecialArgs pkgs)
      // {
        inherit fenix util;
        vscode-extensions = nix-vscode-extensions.extensions.${system};
      };

    baseModulesHomeManager = [
      nixvim.homeManagerModules.nixvim
      ./modules/home
    ];

    mkDarwin = {
      module,
      system ? "aarch64-darwin",
    }: let
      pkgs = mkPkgs system;
    in
      nix-darwin.lib.darwinSystem {
        specialArgs = mkSpecialArgs pkgs;
        modules = [
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          (import ./modules/darwin)
          {
            environment.pathsToLink = ["/share/zsh"];
            home-manager = {
              extraSpecialArgs = mkExtraSpecialArgs pkgs;
              users.${username}.imports = baseModulesHomeManager;
              backupFileExtension = "bakk";
            };
          }
          module
        ];
      };
  in {
    darwinConfigurations."Athena" = mkDarwin {module = import ./modules/hosts/Athena.nix;};
    darwinConfigurations."Alice" = mkDarwin {module = import ./modules/hosts/Alice.nix;};

    nixosConfigurations."Arctic" = let
      system = "aarch64-linux";
      pkgs = mkPkgs system;
    in
      nixpkgs.lib.nixosSystem {
        specialArgs = mkSpecialArgs pkgs;

        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              sharedModules = [nur.hmModules.nur];
              extraSpecialArgs = mkExtraSpecialArgs pkgs;
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
    packages = forAllSystems ({
      pkgs,
      system,
    }: {
      nvim = mkNvim pkgs;
    });
  };
}
