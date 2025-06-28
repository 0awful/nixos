{
  pkgs,
  inputs,
  config,
  ...
}: {
  # Provides the daemon
  services.emacs = {
    enable = true;
    client.enable = true;
    startWithUserSession = true;
  };
  # userland configs
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./config.org;
       defaultInitFile = true;
       package = pkgs.emacs.pkgs.withPackages (epkgs: with epkgs; [
         treesit-grammars.with-all-grammars
       ]);
    };
  };

  #environment.variables = {
    #EMACSLOADPATH = "$HOME/.config/emacs";
   #};


  # home.file.".config/emacs/config.org".source = ./config.org;
  # home.file.".config/emacs/init.el".source = ./init.el;

  # Install language servers and development tools
  home.packages = with pkgs; [
    # Language servers
    nil
    #nodePackages.typescript-language-server
    #rust-analyzer

    # Additional development tools
    ripgrep
    fd
  ];
}
