{ pkgs, lib, inputs, ... }:
let 
  inherit (inputs) nixpkgs nixpkgs-unstable;
in 
{
  # Nix configuration ------------------------------------------------------------------------------
  users.users.britton.home = "/Users/britton";

  nix = {
    #package = lib.mkDefault pkgs.unstable.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };
  services.nix-daemon.enable = true;

  # pins to stable as unstable updates very often
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry = {
    n.to = {
      type = "path";
      path = inputs.nixpkgs;
    };
    u.to = {
      type = "path";
      path = inputs.nixpkgs-unstable;
    };
  };

  # nix.buildMachines = [{
  #   systems = [ "x86_64-linux" ];
  #   supportedFeatures = [ "kvm" "big-parallel" ];
  #   sshUser = "ragon";
  #   maxJobs = 12;
  #   hostName = "ds9";
  #   sshKey = "/Users/ragon/.ssh/id_ed25519";
  #   publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUorQkJYdWZYQUpoeVVIVmZocWxrOFk0ekVLSmJLWGdKUXZzZEU0ODJscFYgcm9vdEBpc28K";
  # }

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.overlays = [
    (final: prev: lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      # Add access to x86 packages system is running Apple Silicon
      pkgs-x86 = import nixpkgs {
        system = "x86_64-darwin";
        config.allowUnfree = true;
      };
    }) 
  ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    promptInit = (builtins.readFile ./../mac-dot-zshrc);
  };

  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    taps = [
      "koekeishiya/formulae"
      #
    ];
    brews = [
      "yabai"
      "skhd"
      # home.nix
      # home.packages
    ];
    casks = [
      "discord"
      "docker"
      "element"
      "firefox"
      "github"
      "google-chrome"
      "istat-menus"
      "iterm2"
      #"lingon-x"
      "little-snitch"
      "logitech-options"
      "monitorcontrol"
      "mqtt-explorer"
      "nextcloud"
      "netnewswire"
      "notion"
      "obs"
      "obsidian"
      "omnidisksweeper"
      "plexamp"
      "prusaslicer"
      "rectangle"
      "signal"
      "slack"
      "spotify"
      "steam"
      "thunderbird"
      "viscosity"
      "visual-studio-code"
      "warp"
      "vlc"
      "wireshark"
      "yubico-yubikey-manager"

      # rogue amoeba
      "audio-hijack"
      "farrago"
      "loopback"
      "soundsource"
    ];
    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Craft" = 1487937127;
      "Infuse" = 1136220934;
      "Microsoft Remote Desktop" = 1295203466;
      "Tailscale" = 1475387142;
      "Wireguard" = 1451685025;

      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
    };
  };

  # macOS configuration
  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowScrollBars = "Always";
    NSGlobalDomain.NSUseAnimatedFocusRing = false;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    NSGlobalDomain.InitialKeyRepeat = 25;
    NSGlobalDomain.KeyRepeat = 4;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    LaunchServices.LSQuarantine = false; # disables "Are you sure?" for new apps
    loginwindow.GuestEnabled = false;
    NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
    NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = 1;
  };
  
  system.defaults.CustomUserPreferences = {
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
        DisableAllAnimations = true;
        NewWindowTarget = "PfDe";
        NewWindowTargetPath = "file://$\{HOME\}/Desktop/";
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        ShowStatusBar = true;
        ShowPathbar = true;
        WarnOnEmptyTrash = false;
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.dock" = {
        autohide = true;
        launchanim = false;
        static-only = false;
        show-recents = false;
        show-process-indicators = true;
        orientation = "left";
        tilesize = 36;
        minimize-to-application = true;
        mineffect = "scale";
      };
      "com.apple.ActivityMonitor" = {
        OpenMainWindow = true;
        IconType = 5;
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };
      "com.apple.Safari" = {
        # Privacy: don’t send search queries to Apple
        AutoFillPasswords = false;
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
        
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };

      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 1;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
      "com.googlecode.iterm2".PromptOnQuit = false;
      "com.google.Chrome" = {
        #AppleEnableSwipeNavigateWithScrolls = false;
        DisablePrintPreview = true;
        PMPrintingExpandedStateForPrint2 = true;
      };
  };

}
