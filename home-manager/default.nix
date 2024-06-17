# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  outputs,
  pkgs,
  # lib,
  ...
}: {
  programs.home-manager.enable = true;

  # pull in the things from folders. Grabs default.nix if a folder is given
  imports = [
    ./wezterm
    ./rice
    ./yazi
    ./gitui
    ./zsh
    ./discord # For discord settings
    ./cargo # Similarly cargo settings
    #./nvim We don't use this at the moment because we use lunarvim
    ./1password # for ssh key management
    ./direnv # faster nix dev
    # ./nixvim
  ];
  # I am not importing all the folders because I don't use all the things, but I want to be able to return to them.
  # The configs live on, but are not a part of the system

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

  # todo: break this out into a git file
  programs.gh.enable = true;

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
