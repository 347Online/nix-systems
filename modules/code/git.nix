{
  config,
  lib,
  system,
  ...
}: let
  isDarwin = lib.hasSuffix "darwin" system;
in {
  options = {
    code.git.enable = lib.mkEnableOption "git setup";
  };

  config = lib.mkIf config.code.git.enable {
    programs.git = {
      enable = true;
      delta.enable = true;
      ignores = [
        ".DS_Store"
        ".rtx.toml"
        ".mise.toml"
      ];
      userName = "347Online | Katie Janzen";
      userEmail = "katiejanzen@347online.me";
      extraConfig = {
        core.editor = "nvim";
        init.defaultBranch = "main";
        credential.helper = lib.mkIf isDarwin "osxkeychain";
      };
    };
    programs.git-credential-oauth.enable = lib.mkIf (!isDarwin) true;
  };
}
