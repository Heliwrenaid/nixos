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

## Recovery
Sometimes eg. BIOS update can remove grub.

1. Create live USB (GPT partition and `DD mode` - not ISO).
2. Mount root and boot partitions:
```sh
sudo mount /dev/<root partition> /mnt
sudo mount /dev/<boot partition> /mnt/boot
```
3. If you have config in /home mount it, copy to root, then unmount. Or download repo from Github.
4. cd to repo
5.
```sh
sudo nixos-enter
unset SUDO_USER
```
6. Disable logrotate. Put in configuration.nix:
```
services.logrotate.enable = false;
```
7. Reinstall bootloader
```
nixos-rebuild boot --flake .#desktop --install-bootloader
```
8. Sometimes it can not detect Windows if you have dual boot config. Then try to reinstall bootloader again from booted NixOS system.