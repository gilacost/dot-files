{ pkgs, ... }: {
  programs.firefox.enable = true;
  # Handled by the Homebrew module
  # This populates a dummy package to satisfy the requirement
  programs.firefox.package = pkgs.runCommand "firefox-0.0.0" { } "mkdir $out";

  # programs.firefox.profiles.myprofile.extensions = with pkgs.nur.repos.rycee.firefox-addons;
  # [
  # # tridactyl
  # onepassword-password-manager
  # ];

  programs.firefox.profiles = let
    userChrome = builtins.readFile ./userChrome.css;
    settings = {
      "app.update.auto" = false;
      "browser.startup.homepage" = "http://elixirweekly.net/";
      "browser.search.region" = "GB";
      "browser.search.countryCode" = "GB";
      "browser.search.isUS" = false;
      "browser.ctrlTab.recentlyUsedOrder" = false;
      "browser.newtabpage.enabled" = false;
      "browser.bookmarks.showMobileBookmarks" = true;
      "browser.uidensity" = 1;
      "browser.cache.disk.enable" = false;
      "devtools.cache.disabled" = true;
      "devtools.theme dark" = "dark";
      "browser.urlbar.placeholderName" = "DuckDuckGo";
      "browser.urlbar.update1" = true;
      "distribution.searchplugins.defaultLocale" = "en-GB";
      "general.useragent.locale" = "en-GB";
      # "identity.fxaccounts.account.device.name" = config.networking.hostName;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
      "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
      "reader.color_scheme" = "sepia";
      "services.sync.declinedEngines" = "addons,passwords,prefs";
      "services.sync.engine.addons" = false;
      "services.sync.engineStatusChanged.addons" = true;
      "services.sync.engine.passwords" = false;
      "services.sync.engine.prefs" = false;
      "services.sync.engineStatusChanged.prefs" = true;
      "signon.rememberSignons" = false;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
    };
  in {
    home = {
      inherit settings;
      inherit userChrome;
      id = 0;
    };

    work = {
      inherit userChrome;
      id = 1;
      settings = settings // {
        "browser.startup.homepage" = "about:blank";
        "browser.urlbar.placeholderName" = "Google";
      };
    };
  };
}
