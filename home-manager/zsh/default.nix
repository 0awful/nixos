{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    autocd = false;
    dotDir = ".config/zsh";
    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #   }
    #   {
    #     name = "powerlevel10k-config";
    #     src = lib.cleanSource ./config;
    #     file = "p10k.zsh";
    #   }
    # ];

    initExtraFirst = ''
      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.cargo/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      # have things find fonts
      export FONTCONFIG_FILE=/etc/fonts/fonts.conf
      export FONTCONFIG_PATH=/etc/fonts

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # export ALTERNATE_EDITOR=""
      export EDITOR="emacsclient -t"
      # export VISUAL="emacsclient -c -a emacs"

      export SSH_AUTH_SOCK=~/.1password/agent.sock
      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Use difftastic, syntax-aware diffing
      alias diff=difft
      alias y=yazi
      alias cd=z
      alias ls=eza
      alias grep=rg
      alias vi=$EDITOR
      alias vim=$EDITOR
      alias godot=godot4
      alias ffs='~/scripts/ffs.sh'
      alias FFS='~/scripts/ffs.sh'
    '';
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
