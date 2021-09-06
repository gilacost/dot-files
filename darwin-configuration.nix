{ config, lib, pkgs, ... }:

{
  ############
  #  System  #
  ############

  time.timeZone = "Europe/London";

  #####TODO##########

  ##bluetooth in menu bar
  #open '/System/Library/CoreServices/Menu Extras/Bluetooth.menu'
  # system.defaults.".GlobalPreferences"."com.apple.screensaver askForPasswordDelay"=1;
  # system.defaults.".GlobalPreferences"."com.apple.screensaver askForPassword"=1;
  # system.defaults.".GlobalPreferences"."com.apple.menuextra.battery"="YES";

  system = {
    defaults = {
      NSGlobalDomain = {
        "com.apple.mouse.tapBehavior" = 1;
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        _HIHideMenuBar = true;
      };

      screencapture.location = "/tmp";

      dock = {
        autohide = true;
        mru-spaces = false;
        orientation = "bottom";
        showhidden = true;
        static-only = true;
      };

      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = false;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

  ############
  # SERVICES #
  ############

  services.skhd = {
    enable = true;
    skhdConfig = builtins.readFile ./conf.d/skhd.conf;
  };

  services.nix-daemon.enable = true;

  # YABAI ####

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      window_border = "on";
      window_border_width = 5;
      active_window_border_color = "0xffd9adad";
      normal_window_border_color = "0xff3b4252";
      focus_follows_mouse = "off";
      mouse_follows_focus = "off";
      mouse_drop_action = "stack";
      window_placement = "second_child";
      window_opacity = "on";
      window_topmost = "on";
      window_shadow = "float";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      split_ratio = "0.50";
      auto_balance = "off";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      layout = "bsp";
      top_padding = 0;
      bottom_padding = 0;
      left_padding = 0;
      right_padding = 0;
      window_gap = 0;
      external_bar = "main:0:0";
    };

    extraConfig = pkgs.lib.mkDefault ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m rule --add app='Live' manage=off
      yabai -m rule --add app='Xcode' manage=off
    '';
  };

  launchd.user.agents.yabai.serviceConfig.StandardErrorPath = "/tmp/yabai.log";
  launchd.user.agents.yabai.serviceConfig.StandardOutPath = "/tmp/yabai.log";

  ############
  # Homebrew #
  ############

  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;
  homebrew.extraConfig = ''
    cask "firefox", args: { language: "en-GB" }
  '';

  homebrew.taps = [ "homebrew/core" "homebrew/cask" ];

  homebrew.casks = [
    "surfshark"
    "transmission"
    "adobe-acrobat-reader"
    "firefox"
    "1password"
    "docker"
    "grammarly"
    "inkscape"
    "recordit"
    "spotify"
    "vlc"
    "kitty"
    "zoom"
    "slack"
  ];

  nix.binaryCachePublicKeys =
    [ "cache.daiderd.com-1:R8KOWZ8lDaLojqD+v9dzXAqGn29gEzPTTbr/GIpCTrI=" ];
  nix.trustedBinaryCaches = [ "https://d3i7ezr9vxxsfy.cloudfront.net" ];
  # review sandboxPaths
  nix.sandboxPaths = [ "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];
  programs.nix-index.enable = true;

  environment.variables.LANG = "en_GB.UTF-8";
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";

  nixpkgs.config.allowUnfree = true;
  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;
}
