{lib, ...}: {
  options = {
    linux = {
      headless.enable = lib.mkEnableOption "headless operation";
    };
  };
}
