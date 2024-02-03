{pkgs, ...}: {
  home.file."./.config/yazi/init.lua".source = ./init.lua;
  home.file."./.config/yazi/keymap.toml".source = ./keymap.toml;
  home.file."./.config/yazi/theme.toml".source = ./theme.toml;
  home.file."./.config/yazi/plugins/smart-enter.yazi/init.lua".source = ./plugins/smart-enter.yazi/init.lua;

  programs.yazi = {
    package = pkgs.unstable.yazi;
    enable = true;
    enableZshIntegration = true;
  };
  # Requires:
  # 1. ffmpegthumbnailer
  # 2. unar
  # 3. poppler
  # 4. fd
  # 5. rg
  # 6. jq (homemanager)
  # 7. fzf (homemanager)
  # 8. zoxide (homemanager)
  programs = {
    jq.enable = true;
    fzf.enable = true;
    zoxide.enable = true;
  };
}
