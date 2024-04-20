{...}: {
  programs.helix = {
    enable = true;
    #defaultEditor = true;
    settings = {
      editor = {
        gutters = ["diff" "diagnostics"];
        middle-click-paste = false;
        auto-save = true;
        bufferline = "always";
        line-number = "relative";
        mouse = false;
        soft-wrap = {
          enable = true;
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };
    };
  };
}
