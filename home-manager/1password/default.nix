_: let
  onePassPath = "~/.1password/agent.sock";
in {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
          IdentityAgent ${onePassPath}
    '';
  };

  home.file.".config/1Password/ssh/agent.toml".source = ./agent.toml;
}
