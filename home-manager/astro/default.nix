{
  outputs,
  pkgs,
  ...
}: {
  # This sets up astro-nvim
  home.file.".config/nvim" = {
    source = ./astro-nvim;
    recursive = true;
  };

  programs = {
    lazygit.enable = true;
    bottom.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      coc.enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
      extraPackages = with pkgs; [
        gcc
        gnumake
      ];
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    xclip
    ripgrep
    python3
    nodejs
    tree-sitter
  ];
}
