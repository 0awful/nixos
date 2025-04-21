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
    extraPackages = epkgs: [
      epkgs.use-package
      epkgs.evil
      epkgs.evil-collection
      epkgs.general
      epkgs.which-key
      epkgs.toc-org
      epkgs.org-bullets
      epkgs.gruvbox-theme
      epkgs.nix-mode
      epkgs.sudo-edit
      epkgs.ivy
      epkgs.ivy-rich
      epkgs.counsel
      epkgs.all-the-icons-ivy-rich
      epkgs.all-the-icons
      epkgs.all-the-icons-dired
      epkgs.avy
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
