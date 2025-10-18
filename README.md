## About

This repository contains the configuration files for my NixOS system installation.

## Useful commands
```sh
# Rebuild whole system
$ sudo nixos-rebuild switch --flake .#desktop

# Rebuild only DE/WM configuration
# Use only for testing. Any changes will be reset after reboot.
$ home-manager switch --flake .
```