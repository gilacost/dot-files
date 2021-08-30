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

  system.defaults.NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
  system.defaults.NSGlobalDomain.AppleKeyboardUIMode = 3;
  system.defaults.screencapture.location = "/tmp";
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "bottom";
  system.defaults.dock.showhidden = true;
  system.defaults.dock.static-only = true;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadThreeFingerDrag = false;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  ############
  # SERVICES #
  ############

  services.skhd = {
    enable = true;
    skhdConfig = ''
      ${builtins.readFile ./conf.d/skhdrc}
    '';
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
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "off";
      mouse_drop_action = "stack";
      window_placement = "second_child";
      window_opacity = "off";
      window_topmost = "on";
      window_shadow = "float";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      split_ratio = "0.50";
      auto_balance = "on";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      layout = "bsp";
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
      external_bar = "main:26:0";
    };

    extraConfig = pkgs.lib.mkDefault ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off
      yabai -m rule --add app='Live' manage=off
      yabai -m rule --add app='Xcode' manage=off
      yabai -m rule --add app='Emacs' title='.*Minibuf.*' manage=off border=off
    '';
  };

  launchd.user.agents.yabai.serviceConfig.StandardErrorPath = "/tmp/yabai.log";
  launchd.user.agents.yabai.serviceConfig.StandardOutPath = "/tmp/yabai.log";

  ############
  # Homebrew #
  ############

  homebrew.enable = true;
  homebrew.autoUpdate = false;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;
  homebrew.extraConfig = ''
    cask "firefox", args: { language: "en-GB" }
  '';
  # cask "font-iosevka-nerd-font", arfs: { family: "Sans-serif" }

  homebrew.taps = [
    "homebrew/core"
    "homebrew/cask"
  ];

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
    "zoom"
    "kitty"
  ];

  nix.extraOptions = ''
    gc-keep-derivations = true
    gc-keep-outputs = true
    min-free = 17179870000
    max-free = 17179870000
    log-lines = 128
  '';

  nix.binaryCachePublicKeys = [ "cache.daiderd.com-1:R8KOWZ8lDaLojqD+v9dzXAqGn29gEzPTTbr/GIpCTrI=" ];
  nix.trustedBinaryCaches = [ https://d3i7ezr9vxxsfy.cloudfront.net ];
  # review sandboxPaths
  nix.sandboxPaths = [ "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];
  programs.nix-index.enable = true;

  environment.variables.LANG = "en_GB.UTF-8";
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";

  nixpkgs.config.allowUnfree = true;
  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;
}
