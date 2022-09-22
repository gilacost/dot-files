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
    enable = false;
    enableScriptingAddition = true;
    package = pkgs.yabai;
    config = {
      # layout
      layout = "bsp";
      auto_balance = "off";
      window_topmost = "off";
      split_ratio = "0.50";
      window_placement = "second_child";
      debug_output = "on";
      # Gaps
      window_gap = 12;
      top_padding = 35;
      bottom_padding = 12;
      left_padding = 12;
      right_padding = 12;
      # shadows and borders
      focus_follows_mouse = "off";
      mouse_follows_focus = "off";
      window_shadow = "float";
      window_border = "on";
      window_border_width = 3;
      window_opacity = "off";
      # mouse
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      # rules
      yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
      yabai -m rule --add label="Firefox" app="^Firefox$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      yabai -m rule --add label="System Preferences" app="^System Preferences$" title=".*" manage=off
      yabai -m rule --add label="App Store" app="^App Store$" manage=off
      yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
      yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
      yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
      yabai -m rule --add label="Software Update" title="Software Update" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
    '';
  };

  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;
    config = {
      position = "top";
      display = "main";
      height = 26;
      title = "on";
      spaces = "on";
      clock = "on";
      power = "on";
      padding_left = 20;
      padding_right = 20;
      spacing_left = 25;
      spacing_right = 15;
      text_font = ''"Iosevka Nerd Font:Regular:12.0"'';
      icon_font = ''"Iosevka Nerd Font:Regular:12.0"'';
      background_color = "0xff202020";
      foreground_color = "0xffa8a8a8";
      power_icon_color = "0xffcd950c";
      battery_icon_color = "0xffd75f5f";
      dnd_icon_color = "0xffa8a8a8";
      clock_icon_color = "0xffa8a8a8";
      power_icon_strip = " ";
      space_icon = "•";
      space_icon_strip = "1 2 3 4 5 6 7 8 9 10";
      spaces_for_all_displays = "on";
      display_separator = "on";
      display_separator_icon = "";
      space_icon_color = "0xff458588";
      space_icon_color_secondary = "0xff78c4d4";
      space_icon_color_tertiary = "0xfffff9b0";
      clock_icon = "";
      dnd_icon = "";
      clock_format = ''"%d/%m/%y %R"'';
      right_shell = "on";
      right_shell_icon = "";
      right_shell_command = "whoami";
    };
  };

  launchd.user.agents.yabai.serviceConfig.StandardErrorPath =
    "/tmp/yabai.error";
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
      "skype"
    ];

    masApps = {
      # "Numbers" = 409203825;
      # Amphetamine = 937984704;
      # Pages = 409201541;
      # Keynote = 409183694;
      # "Surfshark: Unlimited VPN Proxy" = 1437809329;
      # Magnet = 441258766;
    };
  };

  programs.nix-index.enable = true;

  environment.variables.LANG = "en_GB.UTF-8";
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";

  services.activate-system.enable = true;
}
