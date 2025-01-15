Hyprland configuration for NixOS with additional personal use case.

Remember to add channel for home-manager:
```
$ nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
$ nix-channel --update
```
And build it:
```
$ home-manager switch
```
