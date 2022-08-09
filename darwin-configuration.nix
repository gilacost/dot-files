{ config, lib, pkgs, ... }:

{
  environment.shells = [ pkgs.zsh ];

  users = {

    nix.configureBuildUsers = true;
    users = {
      pepo = {
        home = "/Users/pepo";
        shell = pkgs.zsh;
      };
    };
  };
  programs.bash.enable = false;
  programs.zsh.enable = true;

  nix = {
    trustedUsers = [ "root" "pepo" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  ############
  #  System  #
  ############

  time.timeZone = "Europe/London";

  system = {
    defaults = {
      NSGlobalDomain = {
        "com.apple.mouse.tapBehavior" = 1;
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = true;
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
      # Remap backslash to tilde for non-us keyboards
      # more info: https://jonnyzzz.com/blog/2017/12/04/macos-keys/
      # https://www.grzegorowski.com/how-to-remap-single-mac-keyboard-key
      # hidutil property --set '{ "UserKeyMapping":[ \
      #     {"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}, \
      #     {"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064}, \
      #   ] \
      # }'
      enableKeyMapping = true;
      userKeyMapping = [
        ({
          HIDKeyboardModifierMappingSrc = 30064771129;
          HIDKeyboardModifierMappingDst = 30064771296;
        })
        ({
          HIDKeyboardModifierMappingDst = 30064771125;
          HIDKeyboardModifierMappingSrc = 30064771172;
        })
        ({
          HIDKeyboardModifierMappingDst = 30064771172;
          HIDKeyboardModifierMappingSrc = 30064771125;
        })
      ];
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
    enableScriptingAddition = true;
    package = pkgs.yabai;
    config = {
      # layout
      layout = "bsp";
      auto_balance = "on";
      split_ratio = "0.50";
      window_placement = "second_child";
      # Gaps
      window_gap = 18;
      top_padding = 18;
      bottom_padding = 46;
      left_padding = 18;
      right_padding = 18;
      # shadows and borders
      focus_follows_mouse = "off";
      mouse_follows_focus = "on";
      window_shadow = "on";
      window_border = "off";
      window_border_width = 3;
      window_opacity = "on";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      # mouse

      # mouse_modifier = "cmd";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      # rules
      # yabai -m rule --add app=emacs-29.0.50 manage=on
      # yabai -m rule --add app='Firefox Nightly' manage=on
      yabai -m rule --add app='System Preferences' manage=off
      # yabai -m rule --add app='Activity Monitor' manage=off
    '';
  };

  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;
    config = {
      position = "bottom";
      height = 28;
      title = "on";
      spaces = "on";
      power = "on";
      clock = "off";
      right_shell = "off";
      padding_left = 20;
      padding_right = 20;
      spacing_left = 25;
      spacing_right = 25;
      text_font = ''"Menlo:16.0"'';
      icon_font = ''"Menlo:16.0"'';
      background_color = "0xff161616";
      foreground_color = "0xffFFFFFF";
      space_icon_color = "0xff3ddbd9";
      power_icon_strip = " ";
      space_icon_strip = "一 二 三 四 五 六 七 八 九 十";
      spaces_for_all_displays = "on";
      display_separator = "on";
      display_separator_icon = "|";
      clock_format = ''"%d/%m/%y %R"'';
      right_shell_icon = " ";
      right_shell_command = "whoami";
    };
  };

  launchd.user.agents.yabai.serviceConfig.StandardErrorPath = "/tmp/yabai.log";
  launchd.user.agents.yabai.serviceConfig.StandardOutPath = "/tmp/yabai.log";

  ############
  # Homebrew #
  ############

  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";
    global.brewfile = true;
    global.noLock = true;
    extraConfig = ''
      cask "firefox", args: { language: "en-GB" }
    '';

    taps = [ "homebrew/core" "homebrew/cask" ];
    brews = [ "mas" "asciinema" "checkov" "fwup" "coreutils" "ansible" ];

    casks = [
      "omnigraffle"
      "db-browser-for-sqlite"
      "virtualbox"
      "google-chrome"
      "lens"
      "transmission"
      "adobe-acrobat-reader"
      "firefox"
      "kitty"
      "remarkable"
      # "surfshark"
      "1password"
      "docker"
      "grammarly"
      "inkscape"
      "recordit"
      "spotify"
      "vlc"
      "zoom"
      "slack"
      "pop"
    ];

    masApps = {
      # Amphetamine = 937984704;
      # Pages = 409201541;
      # Keynote = 409183694;
      # "Surfshark: Unlimited VPN Proxy" = 1437809329;
    };
  };

  programs.nix-index.enable = true;

  environment.variables.LANG = "en_GB.UTF-8";
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";

  services.activate-system.enable = true;
}
