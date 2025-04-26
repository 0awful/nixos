{
  pkgs,
  inputs,
  config,
  ...
}: {
  # Provides the daemon
  services.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };
  # userland configs
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    extraPackages = epkgs: with epkgs; [
      use-package
      evil
      evil-collection
      general
      which-key
      toc-org
      org-bullets
      gruvbox-theme
      nix-mode
      sudo-edit
      all-the-icons-ivy-rich
      all-the-icons
      all-the-icons-dired
      avy
      vertico
      marginalia
      consult
      embark
      embark-consult
      orderless
    ];
  };

  # Copy the config.org file to ~/.config/emacs/config.org
  home.file.".config/emacs/config.org".source = ./config.org;
  home.file.".config/emacs/init.el".source = ./init.el;

  # Install language servers and development tools
  home.packages = with pkgs; [
    # Language servers
    nil
    nodePackages.typescript-language-server
    rust-analyzer

    # Additional development tools
    ripgrep
    fd
  ];
}
