{
  imports = [
    ./hardware-configuration.nix
  ];

  linux.headless = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  networking.hostName = "Arukenia";
  time.timeZone = "America/Chicago";

  # DO NOT EDIT
  system.stateVersion = "24.11";
}
