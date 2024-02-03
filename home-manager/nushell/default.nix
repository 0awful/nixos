{pkgs, ...}: {
  # home.file."./.config/oh-my-posh.nu".source = ./oh-my-posh.nu;
  # home.file."./.config/carapace.nu".source = ./carapace.nu;
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    shellAliases = {
      vi = "hx";
      vim = "hx";
      nano = "hx";
      cd = "z";
      cat = "bat";
      grep = "rg";
      y = "yazi";
    };
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = true;
      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };
    };
  };

  # programs.oh-my-posh = {
  # enable = true;
  # package = pkgs.unstable.oh-my-posh;
  # };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
  # programs.carapace = {
  # package = pkgs.unstable.carapace;
  # enable = true;
  # enableNushellIntegration = true;
  # };
}
