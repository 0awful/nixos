{nixpkgs, ...}: {
  nixpkgs.programs = {
    enable = true;
    colorschemes.gruvbox.enable = true;
  };
}
