{
  lib,
  config,
  isDarwin,
  ...
}:
lib.mkIf config.shared.gui.enable {
  programs.firefox = {
    enable = lib.mkIf (!isDarwin) true;

    profiles.katie = {
      isDefault = true;
      extraConfig =
        # js
        ''
          user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
          user_pref("browser.startup.page", 3);
        '';
      extensions = with config.nur.repos.rycee.firefox-addons; [
        onepassword-password-manager
        darkreader
        youtube-shorts-block
        ublock-origin
      ];
    };
  };
}
