# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  virtualisation.virtualbox.guest.enable = true;
  nix.settings = {
    trusted-users = ["guest"];
    substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://cache.nixos.org"
    ];

    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
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
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.fenix.overlays.default

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

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

  networking.hostName = "guest";
  networking.networkmanager.enable = true;

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    configurationLimit = 5; # TODO: Higher on main machine
  };

  time.timeZone = "America/Los_Angeles";

  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "xfce";
    };

    desktopManager.xfce.enable = true;

    # Make caps control.
    xkb = {
      options = "ctrl:nocaps";
      layout = "us";
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

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  environment.systemPackages = with pkgs; [
    # Rust (I'd love this to be a ./rust)
    gcc
    lld
    clang
    pkgs.unstable.mold
    rust-analyzer-nightly
    (inputs.fenix.packages.${pkgs.system}.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])

    # Notifications
    dunst

    unar
    poppler
    ffmpegthumbnailer
    fd
    firefox
    git
    nerdfonts
    helix
    linuxKernel.packages.linux_6_1.virtualboxGuestAdditions
    inputs.home-manager.packages.${pkgs.system}.default
    xclip
    gh
    eza
    zsh-powerlevel10k
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
  ];
  programs.zsh.enable = true;

  environment.variables = {
    SHELL = "zsh";
    EDITOR = "hx";
    TERMINAL = "wezterm";
    BROWSER = "firefox";
  };
  users.users = {
    guest = {
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "guest";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      shell = pkgs.zsh;
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      guest = import ../home-manager;
    };
  };
  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     # Forbid root login through SSH.
  #     PermitRootLogin = "no";
  #     # Use keys only. Remove if you want to SSH using password (not recommended)
  #     PasswordAuthentication = false;
  #   };
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
