{inputs, ...}: {
  programs.firefox = {
    enable = true;
    enableGnomeExtensions = true;
    # librewolf = true;
    profiles."guest" = {
      isDefault = true;
      # extensions = with inputs.nur.repos.rycee.firefox-addons; [
      # privacy-badger
      # 1password
      # vimium
      # ublock-origin
      # ];
      # search = {
      # force = true; #why?
      # default = "startpage";
      # order = ["startpage" "wikipedia"];
      # engines = {
      # "startpage" = {
      # urls = [{template = "";}];
      # iconUpdateUrl = "";
      # updateInterval = 60 * 60 * 24 * 1000;
      # };
      # };
      # };
    };
  };
}
