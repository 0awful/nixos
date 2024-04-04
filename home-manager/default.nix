# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  outputs,
  pkgs,
  # lib,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./helix.nix
    # ./hyprland
    # ./nusheel
    # ./alacritty.nix
    # ./firefox #Broken. no NUR and colliding configs
    ./wezterm
    ./rice
    ./yazi
    ./gitui
    ./zsh
    ./discord # For discord settings
    ./cargo # Similarly cargo settings
    ./nvim
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;

      permittedInsecurePackages = [
        "electron-25.9.0" # for discord
      ];
    };
  };

  home = {
    username = "guest";
    homeDirectory = "/home/guest";
  };

  home.packages = with pkgs; [
    # Discord, obviously...
    unstable.discord
    # second brain
    obsidian
    # game dev
    unstable.ldtk
    blender
    unstable.godot_4
    # steam
    steam
  ];

  programs.gh.enable = true;

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    ignores = ["*.swp"];
    userName = "0Awful";
    userEmail = "im.izaac.seo@gmail.com";
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "neovide";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
