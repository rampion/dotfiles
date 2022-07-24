Log of changes made to non-user-specific files.

# 2022-07-23
## Get GNOME working
To get NixOS install to run GNOME successfully at startup, needed it to run a
newer linux kernel; altered `/etc/nixos/configuration.nix` to use the latest
linux kernel:

```diff
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
+ boot.kernelPackages = pkgs.linuxPackages_latest;
```

See https://discourse.nixos.org/t/nixos-22-05-gnome-iso-didnt-put-gnome-session-in-path/20533/8 for more details.

# 2022-07-24
## Enable Home Manager
To enable `home-manager`, just include it as a package for the user account in `/etc/nixos/configuration.nix`:

```diff
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rampion = {
    isNormalUser = true;
    description = "Noah Luck Easterly";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
+     home-manager
      firefox
-   #  thunderbird
    ];
  };
```

This doesn't define the needed `~/.config/nixpkgs/home.nix` file, though. That must be defined manually.

## Change shell to zsh
This [can't be changed using home-manager](https://discourse.nixos.org/t/using-home-manager-to-control-default-user-shell/8489),
but must be [set in the user configuration](https://unix.stackexchange.com/questions/384040/how-to-change-the-default-shell-in-nixos)
in `/etc/nixos/configuration.nix`

```diff
  users.users.rampion = {
    isNormalUser = true;
    description = "Noah Luck Easterly";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      home-manager
      firefox
    ];
+   shell = pkgs.zsh;
  };
```
