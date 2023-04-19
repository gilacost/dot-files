{ config, lib, pkgs, ... }:

{
  environment.shells = [ pkgs.zsh ];
  users = {
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
    configureBuildUsers = true;
    settings = { trusted-users = [ "root" "pepo" ]; };
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
    activationScripts.postActivation.text = ''
      # TODO: Rewrite as much of these as possible using nix-darwin
      # From https://github.com/mathiasbynens/dotfiles/blob/master/.macos taken
      # at commit e72d1060f3df8c157f93af52ea59508dae36ef50.
      ###############################################################################
      # General UI/UX                                                               #
      ###############################################################################
      # Disable the sound effects on boot
      sudo nvram SystemAudioVolume=" "
      # Disable UI alert audio
      defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0
      # todo FLASH
      # plutil -convert xml1 -o - ~/Library/Preferences/com.apple.universalaccess.plist|grep -A1 flashScreen
      # <key>flashScreen</key> <false/>
      # Set highlight color to ORANGE
      defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"
      # Automatically quit printer app once the print jobs complete
      defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
      # Reveal IP address, hostname, OS version, etc. when clicking the clock
      # in the login window
      sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
      # Restart automatically if the computer freezes
      sudo systemsetup -setrestartfreeze on
      # Never go into computer sleep mode
      sudo systemsetup -setcomputersleep Off > /dev/null
      # Disable Notification Center and remove the menu bar icon
      launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null
      ###############################################################################
      # SSD-specific tweaks                                                         #
      ###############################################################################
      # Disable hibernation (speeds up entering sleep mode)
      sudo pmset -a hibernatemode 0
      ###############################################################################
      # Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
      ###############################################################################
      # Shows battery percentage
      defaults write com.apple.menuextra.battery ShowPercent YES; killall SystemUIServer
      # Increase sound quality for Bluetooth headphones/headsets
      defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
      # Follow the keyboard focus while zoomed in
      defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
      # Show language menu in the top right corner of the boot screen
      sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true
      # Set language and text formats
      # Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
      # `Inches`, `en_GB` with `en_US`, and `true` with `false`.
      defaults write NSGlobalDomain AppleLanguages -array "en"
      defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=GBP"
      defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
      defaults write NSGlobalDomain AppleMetricUnits -bool true
      # Stop iTunes from responding to the keyboard media keys
      launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2>/dev/null
      ###############################################################################
      # Screen                                                                      #
      ###############################################################################
      # Require password immediately after sleep or screen saver begins
      defaults write com.apple.screensaver askForPassword -int 1
      defaults write com.apple.screensaver askForPasswordDelay -int 0
      # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
      defaults write com.apple.screencapture type -string "png"
      # Disable shadow in screenshots
      defaults write com.apple.screencapture disable-shadow -bool true
      # Enable HiDPI display modes (requires restart)
      sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
      ###############################################################################
      # Finder                                                                      #
      ###############################################################################
      # Finder: disable window animations and Get Info animations
      defaults write com.apple.finder DisableAllAnimations -bool true
      # Set Desktop as the default location for new Finder windows
      # For other paths, use `PfLo` and `file:///full/path/here/`
      defaults write com.apple.finder NewWindowTarget -string "PfDe"
      defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/Desktop/"
      # Show icons for hard drives, servers, and removable media on the desktop
      defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
      defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
      defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
      defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
      # Finder: show status bar
      defaults write com.apple.finder ShowStatusBar -bool true
      # Finder: show path bar
      defaults write com.apple.finder ShowPathbar -bool true
      # Keep folders on top when sorting by name
      defaults write com.apple.finder _FXSortFoldersFirst -bool true
      # When performing a search, search the current folder by default
      defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
      # Avoid creating .DS_Store files on network or USB volumes
      defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
      defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
      # Automatically open a new Finder window when a volume is mounted
      defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
      defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
      defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
      # Use list view in all Finder windows by default
      # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
      defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
      # Disable the warning before emptying the Trash
      defaults write com.apple.finder WarnOnEmptyTrash -bool false
      # Enable AirDrop over Ethernet and on unsupported Macs running Lion
      defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
      # Show the ~/Library folder
      chflags nohidden ~/Library
      # Show the /Volumes folder
      sudo chflags nohidden /Volumes
      # Expand the following File Info panes:
      # “General”, “Open with”, and “Sharing & Permissions”
      defaults write com.apple.finder FXInfoPanesExpanded -dict \
        General -bool true \
        OpenWith -bool true \
        Privileges -bool true
    '';
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

  ############
  # Homebrew #
  ############

  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      autoUpdate = true;
      cleanup = "zap";
    };

    global = {
      autoUpdate = true;
      brewfile = true;
      lockfiles = true;
    };

    extraConfig = ''
      cask "firefox", args: { language: "en-GB" }
    '';

    taps = [ "homebrew/core" "homebrew/cask" ];
    brews = [ "mas" "asciinema" "checkov" "fwup" "coreutils" "ansible" ];

    casks = [
      "chromium"
      "google-drive"
      "now-tv-player"
      "OmniGraffle"
      "sketch"
      "google-chrome"
      "microsoft-teams"
      # "virtualbox"
      "google-chrome"
      "transmission"
      "adobe-acrobat-reader"
      "firefox"
      "kitty"
      "remarkable"
      "1password"
      "docker"
      "grammarly"
      "recordit"
      "spotify"
      "vlc"
      "zoom"
      "slack"
      "skype"
      "vmware-fusion"
      "discord"
      "insomnia"
    ];

    masApps = {
      "Numbers" = 409203825;
      Amphetamine = 937984704;
      Pages = 409201541;
      Keynote = 409183694;
      "Surfshark: Unlimited VPN Proxy" = 1437809329;
      Magnet = 441258766;
      "TickTick:To-Do List, Calendar" = 966085870;
    };
  };

  programs.nix-index.enable = true;
  environment.variables.LANG = "en_GB.UTF-8";
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";
  services.activate-system.enable = true;
}
