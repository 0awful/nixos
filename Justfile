##########################################################################
#
# Nix commands for local machine
#
##########################################################################

format:
  nix fmt

fmt:
  just format

init:
  echo "this isn't implemented, but should run the commands to enable nixos to first time execute this program"

apply:
  nixos-rebuild switch --flake .#guest --use-remote-sudo

debug:
  nixos-rebuild switch --flake .#guest --show-trace --verbose --use-remote-sudo

boot:
  nixos-rebuild boot --flake .#guest --use-remote-sudo

update:
  nix flake update

update-package:
  nix flake lock --update-input $(i)

history:
  nix profile history --profile /nix/var/nix/profiles/system

clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

gc:
  sudo nix-collect-garbage --delete-old

##########################################################################
#
# Additional setup
#
##########################################################################

