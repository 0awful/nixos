# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nix.settings = {
    trusted-users = ["guest"];
    substituters = [
      "https://nix-community.cachix.org"
      # "https://hyprland.cachix.org"
      "https://cache.nixos.org"
    ];

    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixvim.nixosModules.nixvim
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      inputs.self.overlays.mako-fix
     
      # Add overlays your own flake exports (from overlays and pkgs dir):
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
      inputs.self.overlays.emacs-packages

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #  });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };
  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 15;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.initrd.luks.devices."luks-7e224310-4795-40ef-8cfe-035ab0904364".device = "/dev/disk/by-uuid/7e224310-4795-40ef-8cfe-035ab0904364";

  networking.hostName = "nixos"; # Define your hostname.
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];

  networking = {
    wireless = {
      enable = true;
      userControlled.enable = true;
      extraConfig = ''
        ctrl_interface=/run/wpa_supplicant
        ctrl_interface_group=wheel
        update_config=1
      '';
    };
    networkmanager = {
      enable = false;
      wifi = {
        powersave = false;
        macAddress = "preserve";
      };
      logLevel = "DEBUG";
    };
  };
  services.connman = {
    enable = true;
    extraConfig = ''
      [General]
      AllowHostnameUpdates=false
      PreferredTechnologies=wifi,ethernet
      # Disable WiFi power saving
      WiFiPowerSave=off

      [WiFi]
      # Disable internal WiFi power management
      DisablePowerManagement=true
      # Disable periodic scans when connected
      DisablePeriodicScan=true
    '';
  };
  # ==============================================================================
  # =  Dbus                                                       =
  # ==============================================================================

 services.dbus.enable = true;

  # ==============================================================================
  # = Prevent hibernation                                                        =
  # ==============================================================================

  services.logind = {
    lidSwitch = "suspend";
    extraConfig = ''
      HandleHibernateKey = ignore
      HandleHibernateSleep = ignore
      IdleAction = ignore
    '';
  };

  systemd.sleep.extraConfig = ''
    AllowHibernation = no
    AllowSuspendThenHibernate = no
  '';

  # ==============================================================================
  # = Fix for 'old laptop' wifi chipset issues.                                  =
  # ==============================================================================

  # Make sure firmware is available
  hardware.enableAllFirmware = true;
  # System-wide power management settings
  powerManagement = {
    enable = true; # Keep enabled but configure for performance
    cpuFreqGovernor = "performance"; # Always run CPU at full speed
  };

  # Disable various power management services
  services.power-profiles-daemon.enable = false; # Disable power profiles
  services.tlp.enable = false; # Disable TLP if it's enabled
  services.thermald.enable = false; # Disable Intel's thermal daemon

  # Add kernel parameters to disable more power saving features
  boot.kernelParams = [
    "intel_idle.max_cstate=1" # Limit CPU power saving states
    "pcie_aspm=off" # Disable PCIe power saving
  ];

  # ==============================================================================

  services.usbmuxd.enable = true;

  # Mount some devices
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Enlightenment Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.enlightenment.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable acpid
  services.acpid.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  environment.variables = {
    SHELL = "zsh";
    TERMINAL = "wezterm";
    BROWSER = "firefox";
  };
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      guest = {
        initialPassword = "guest";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
        ];
        extraGroups = ["wheel" "networkmanager" "docker"];
      };
    };
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "guest";
  # Make caps control.
  services.xserver.xkb = {
    options = "ctrl:nocaps";
    layout = "us";
    variant = "";
  };

  # Mozilla Vpn
  services.mozillavpn.enable = true;

  # Enable the 1Password CLI, this also enables a SGUID wrapper so the CLI can authorize against the GUI app
  programs._1password = {
    enable = true;
  };

  # Enable the 1Passsword GUI with myself as an authorized user for polkit
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["guest"];
  }; # 1password setup
  # programs._1password-cli.enable = true;

  programs.zsh.enable = true;
  # set up nerdfonts
  fonts.packages = with pkgs; [
    nerdfonts
    emacs-all-the-icons-fonts
  ];
  fonts.fontDir.enable = true;

  environment.systemPackages = with pkgs; [
    # C compilers
    clang
    gcc

    # Os level text editing
    emacs

    # networking tools
    networkmanager
    networkmanagerapplet
    iw
    pciutils
    usbutils
    ethtool
    linux-firmware
    tcpdump
    wavemon

    # Connman tools
    cmst
    connman-gtk
    connman-ncurses

    # iphone
    libimobiledevice
    ifuse # allows mounting over iPhone

    # Videoplayer
    vlc

    # Audio Recording
    audacity

    # Notifications
    dunst

    # n64 emu
    unstable.rmg

    # gamecube/wii emu
    dolphin-emu

    pcmanfm

    ## Unorg
    ## --------------
    ## unstable.godot_4 temp disable
    tree
    lazygit
    unar
    poppler
    ffmpegthumbnailer
    fd
    firefox
    ungoogled-chromium
    google-chrome
    chromium
    git
    helix
    linuxKernel.packages.linux_6_1.virtualboxGuestAdditions
    inputs.home-manager.packages.${pkgs.system}.default
    xclip
    gh
    eza
    # zsh-powerlevel10k Disabled because homemanager should handle
    ripgrep
    ripgrep-all
    speedtest-rs
    wiki-tui
    cargo-info
    coreutils
    bat
    tealdeer
    grex
    hyperfine
    tokei
    sd
    procs
    zoxide
    zellij
    just
    bacon
    nil
    dmenu-rs
    ## Unorg end ----------
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gedit # text editor
    cheese # webcam tool
    gnome-music
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-terminal
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs ;};
    users = {
      guest = import ../home-manager;
    };
  };

  # Make tapped caps escape.
  services.interception-tools = let
    dfkConfig = pkgs.writeText "dual-function-keys.yaml" ''
      MAPPINGS:
        - KEY: KEY_CAPSLOCK
          TAP: KEY_ESC
          HOLD: KEY_LEFTCTRL
    '';
  in {
    enable = true;
    plugins = lib.mkForce [
      pkgs.interception-tools-plugins.dual-function-keys
    ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${dfkConfig} | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [[KEY_CAPSLOCK, KEY_ESC, KEY_LEFTCTRL]]
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
