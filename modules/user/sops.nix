{ self, homeDirectory, ... }:
{
  sops = {
    defaultSopsFile = self + builtins.toPath "/secrets.yaml";
    defaultSopsFormat = "yaml";

    age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";

    secrets =
      let
        basePath = "${homeDirectory}/.secrets";
      in
      {
        syncthing-gui-passwd.path = "${basePath}/syncthing-gui-passwd.txt";
      };
  };
}
