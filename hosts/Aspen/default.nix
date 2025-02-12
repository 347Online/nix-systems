{
  self,
  username,
  ...
}:
{
  imports = [
    ./services

    ./hardware-configuration.nix
    # ./wireguard.nix
  ];

  stylix.image = "${self}/wallpapers/desert.jpg";

  home-manager.users.${username} = {
    user.personal.enable = true;

    services.syncthing.guiAddress = "0.0.0.0:8384";

    programs.ssh = {
      matchBlocks = {
        DeskPhone = {
          hostname = "192.168.4.245";
          user = "cisco";
          extraOptions = {
            MACs = "+hmac-sha1,hmac-sha1-96,hmac-md5,hmac-md5-96";
            Ciphers = "+aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc";
            HostkeyAlgorithms = "+ssh-rsa";
            PubkeyAcceptedKeyTypes = "+ssh-rsa";
          };
        };
      };
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 8384 ];
      allowedUDPPorts = [ 69 ];
    };

    hostName = "Aspen";
  };
  time.timeZone = "America/Chicago";

  # Enables cross-build to ARM systems
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # DO NOT EDIT
  system.stateVersion = "24.11";
}
