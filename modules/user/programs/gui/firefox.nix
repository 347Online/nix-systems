{
  pkgs,
  config,
  lib,
  username,
  homeDirectory,
  ...
}:
let
  profilePath =
    if pkgs.stdenv.isLinux then
      "${homeDirectory}/.mozilla/firefox/katie"
    else
      "${homeDirectory}/Library/Application Support/Firefox/Profiles/katie";
  ext = {
    _1password = "{d634138d-c276-4fc8-924b-40a0ea21d284}";
    ublock-origin = "uBlock0@raymondhill.net";
  };
  extList = (builtins.attrValues ext) ++ [
    "addons-search-detection@mozilla.com"
    "default-theme@mozilla.org"
    "formautofill@mozilla.org"
    "pictureinpicture@mozilla.org"
    "screenshots@mozilla.org"
    "webcompat-reporter@mozilla.org"
    "webcompat@mozilla.org"
  ];
in
lib.mkIf config.user.gui.enable {
  # TODO: Extension preferences
  home.file."${profilePath}/extensions-preferences.json".text = builtins.toJSON (
    lib.mergeAttrsList (
      builtins.map (x: {
        ${x} = {
          permissions = builtins.filter (x: x != null) [
            "internal:privateBrowsingAllowed"
            (if lib.hasInfix "@mozilla" x then "internal:svgContextPropertiesAllowed" else null)
          ];
          origins = [ ];
        };
      }) extList
    )
  );

  programs.firefox = {
    enable = true;
    package = lib.mkIf pkgs.stdenv.isDarwin null;

    profiles.${username} = {
      search = {
        force = true;
        default = "Google (Fixed)";
        order = [
          "Google (Fixed)"
          "DuckDuckGo"
        ];
        engines = {
          Google.metaData.hidden = true;
          Bing.metaData.hidden = true;
          "Google (Fixed)" = {
            metaData.alias = "@google";
            urls = [
              {
                template = "https://www.google.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "udm";
                    value = "14";
                  }
                ];
              }
            ];
          };
        };
      };

      # extensions = with config.nur.repos.rycee.firefox-addons; [
      #   darkreader
      #   onepassword-password-manager
      #   ublock-origin
      #   # youtube-shorts-block
      # ];

      settings = lib.mkMerge (
        (builtins.map (x: {
          "extensions.quarantineIgnoredByUser.${x}" = true;
        }) extList)
        ++ [
          {
            "browser.aboutConfig.showWarning" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.startup.page" = 3;
            "browser.tabs.inTitlebar" = 1;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.warnOnQuitShortcut" = false;
            "datareporting.policy.dataSubmissionPolicyBypassNotification" = true;
            "identity.sync.tokenserver.uri" = "https://firefox.fatgirl.cloud/1.0/sync/1.5";
            "signon.rememberSignons" = false;

            "browser.uiCustomization.state" = builtins.toJSON rec {
              placements = {
                widget-overflow-fixed-list = [ ];
                unified-extensions-area = [
                  "ublock0_raymondhill_net-browser-action"
                ];
                nav-bar = [
                  "back-button"
                  "forward-button"
                  "stop-reload-button"
                  "urlbar-container"
                  "downloads-button"
                  "_${ext._1password}_-browser-action"
                  "addon_darkreader_org-browser-action"
                ];
                toolbar-menubar = [
                  "menubar-items"
                ];
                TabsToolbar = [
                  "tabbrowser-tabs"
                  "new-tab-button"
                  "alltabs-button"
                ];
                vertical-tabs = [ ];
                PersonalToolbar = [ "personal-bookmarks" ];
              };
              dirtyAreaCache = builtins.attrNames placements;
              currentVersion = 20;
            };
          }
        ]
      );
    };
  };
}
