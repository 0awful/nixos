{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # nixvim = inputs.nixvim.homeManagerModules.nixvim;
    # nixssss = inputs.garbage.that.doesnt.exist;
  };
# Add to your overlays
mako-fix = final: prev: {
  formats = prev.formats // {
    ini = args: let 
      result = prev.formats.ini args;
    in result // {
      lib = { 
        types = { 
          atom = prev.lib.types.str; 
        }; 
      };
    };
  };
};
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  emacs-packages = inputs.emacs-overlay.overlay;
}
