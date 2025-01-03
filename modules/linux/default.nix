{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [
    ./keyd.nix
    ./nix.nix
    ./options.nix
    ../shared/stylix.nix
  ];

  config = lib.mkMerge [
    {
      security.pam = {
        services = {
          login.u2fAuth = true;
          sudo.u2fAuth = true;
        };
        # yubico = {
        #   enable = true;
        #   mode = "challenge-response";
        #   id = ["28646857"];
        # };
      };

      services = {
        # pcscd.enable = true;
        openssh.enable = true;
        printing.enable = true;
        fwupd.enable = true;
        # udev.packages = with pkgs; [
        #   yubikey-personalization
        #   libu2f-host
        # ];
      };

      users.users.katie = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" ];
      };

      programs.git.enable = true;
      programs.zsh.enable = true;
      programs._1password.enable = true;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      # home.file = util.toHomeFiles ./dotfiles;

      environment.systemPackages = with pkgs; [
        vim
        killall
        pciutils
        usbutils
        screen
        ookla-speedtest
      ];
    }

    (lib.mkIf config.linux.gui.enable {
      programs._1password-gui.enable = true;

      networking.networkmanager.enable = true;

      services.desktopManager.plasma6.enable = true;
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      environment.systemPackages = with pkgs; [
        acpi
        firefox
      ];

      home-manager = {
        users.${username} = {
          home.packages = with pkgs; [
            # Electron Apps
            # webcord
            # element-desktop # TODO: Only if a private machine
            # obsidian
            paper-plane
          ];
        };
      };
    })
  ];
}
