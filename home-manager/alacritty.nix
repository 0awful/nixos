{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      selection.save_to_clipboard = true;
      window = {
        opacity = 0.95;
        blur = true;
        decorations = "None";
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
      };
      cursor = {
        shape = "Beam";
        blinking = "On";
        vi_mode_style = {
          shape = "Underline";
          blinking = "Off";
        };
      };
      mouse = {
        hide_when_typing = true;
      };
    };
  };
}
