{
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
    };

    NSGlobalDomain = {
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
    };

    CustomSystemPreferences = {
      "com.apple.Safari" = {
        AutoOpenSafeDownloads = false;
        ShowFavoritesBar = true;
        IncludeDevelopMenu = true;
        WebAutomaticSpellingCorrectionEnabled = false;
        WebKitTabToLinksPreferenceKey = true;
      };
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        TSWPAutomaticSpellingCorrection = false;
      };

      "com.apple.dock" = {
        wvous-br-corner = 4;
        wvous-br-modifier = 1048576;
      };

      "com.apple.WindowManager" = {
        EnableStandardClickToShowDesktop = 0;
        HasDisplayedShowDesktopEducation = 1;
      };

      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };

      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };

      "com.apple.print.PrintingPrefs" = {
        # Automatically quit printer app once the print jobs complete
        "Quit When Finished" = true;
      };

      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        ScheduleFrequency = 1;
        AutomaticDownload = 1;
        CriticalUpdateInstall = 1;
      };

      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      "com.apple.ImageCapture".disableHotPlug = true;
      "com.apple.commerce".AutoUpdate = true;

      "com.pilotmoon.scroll-reverser" = {
        StartAtLogin = true;
        HideIcon = true;
        ReverseTrackpad = false;
        InvertScrollingOn = true;
        ReverseX = true;
      };

      "io.fadel.missioncontrolplus.preferences" = {
        HideMenubarItem = true;
      };

      "com.witt-software.Rocket-Typist-setapp" = {
        AbbreviationDelimiterKey = 1;
        AbbreviationsTriggerType = 1;
        AutoPasteEnabled = true;
        WelcomeViewHasBeenShown = true;
        ShowRTInMenuBar = false;
      };

      "com.raycast.macos" = {
        raycastGlobalHotkey = "Command-49";
        useHyperKeyIcon = true;
        onboardingCompleted = true;
        "onboarding_setupHotkey" = true;
        "NSStatusItem Visible raycastIcon" = false;
        "emojiPicker_skinTone" = "standard";
      };
    };
  };
}
