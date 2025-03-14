# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  outputs,
  pkgs,
  ...
}: {
  # let home-manager control itself
  programs.home-manager.enable = true;
  # let home-manager help programs find fonts (technically manage your font config)
  fonts = {
    fontconfig.enable = true;
  };

  # You'll never be upset to have an editorconfig
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 78;
        indent_style = "space";
        indent_size = 2;
      };
    };
  };

  # pull in the things from folders. Grabs default.nix if a folder is given
  imports = [
    ./wezterm
    ./rice
    ./gitui
    ./zsh
    ./emacs
    ./discord # For discord settings
    ./cargo # Similarly cargo settings
    # ./nvim
    ./1password # for ssh key management
    ./direnv # faster nix dev
    ./astro
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
    # steam
    steam

    # Fonts seem to be a nightmare...
    nerdfonts
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
        editor = "emacs";
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
