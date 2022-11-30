# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# Run `sudo nixos-rebuild switch` to update.

{ config, pkgs, ... }:
let
  mercury = import "${
      builtins.fetchGit {
        url = "git@github.com:MercuryTechnologies/nixos-configuration.git";
        ref = "main";
        rev = "8d1b65f5640678e1503c69daf6e511ac2d37688c";
      }
    }/nixos-modules";

  # NixOS profiles to optimize settings for different hardware.
  #
  # suggested by slack
  # https://mercurytechnologies.slack.com/archives/C0250PY5G74/p1664381912743859?thread_ts=1664371470.070019&cid=C0250PY5G74
  #
  # But darp8 is not yet available.
  ##nixos-hardware = import "${
  ##    builtins.fetchGit {
  ##      url = "https://github.com/NixOS/nixos-hardware.git";
  ##    }
  ##  }/system76/darp8";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #nixos-hardware

      # mercury-specific configuration
      mercury
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # enable a memtest app at bootloader to test RAM
  boot.loader.grub.memtest86.enable = true;
  # default kernel for NixOS-22.05 wasn't working for this laptop
  # (5.15.55), but a later one did (5.18.12)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.system76.enableAll = true; # use recommended System76 configuration

  networking.hostName = "johrlac";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # This service prevents `nixos-rebuild switch` from completing
  #
  #   warning: the following units failed: NetworkManager-wait-online.service
  #
  #   × NetworkManager-wait-online.service - Network Manager Wait Online
  #        Loaded: loaded (/etc/systemd/system/NetworkManager-wait-online.service; enabled; vendor preset: enabled)
  #       Drop-In: /nix/store/7anjgivk775m3wwsqpzk9bymq5wyzri7-system-units/NetworkManager-wait-online.service.d
  #                └─overrides.conf
  #        Active: failed (Result: exit-code) since Tue 2022-11-29 14:57:01 EST; 18ms ago
  #          Docs: man:nm-online(1)
  #       Process: 717295 ExecStart=/nix/store/zywjmwncjwi9d6pw4n74lzjbg20p7mjz-networkmanager-1.38.4/bin/nm-online -s -q (code=exited, status=1/FAILURE)
  #      Main PID: 717295 (code=exited, status=1/FAILURE)
  #            IP: 0B in, 0B out
  #           CPU: 45ms
  #
  #   Nov 29 14:56:01 johrlac systemd[1]: Starting Network Manager Wait Online...
  #   Nov 29 14:57:01 johrlac systemd[1]: NetworkManager-wait-online.service: Main process exited, code=exited, status=1/FAILURE
  #   Nov 29 14:57:01 johrlac systemd[1]: NetworkManager-wait-online.service: Failed with result 'exit-code'.
  #   Nov 29 14:57:01 johrlac systemd[1]: Failed to start Network Manager Wait Online.
  #
  # Apparently the underlying command, `nm-online` will often return an error
  # code if the system has been up for an extended period of time.
  #
  #   johrlac# uptime
  #    15:06:32  up 2 days  2:41,  1 user,  load average: 0.95, 1.05, 1.36
  #   johrlac# nm-online -s -q
  #   johrlac# echo $?
  #   1
  #
  # For more details see this thread
  # https://github.com/NixOS/nixpkgs/issues/180175
  #systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [
    pkgs.hplipWithPlugin
  ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nix = {
    # Allow users with sudo access to specify additional binary caches, etc
    # see `man 5 nix.conf`
    settings.trusted-users = [ "@wheel" ];

    # Allow users to use builtins.doc to get documentation in the nix repl
    # see https://github.com/lf-/nix-doc#nix-plugin-1
    extraOptions = ''
      plugin-files = ${pkgs.nix-doc}/lib/libnix_doc_plugin.so
    '';
  };

  # set up cron jobs
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 0 * * *	rampion	find ~/.backup -not -newerat '1 month ago' -delete"
    ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rampion = {
    isNormalUser = true;
    description = "Noah Luck Easterly";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      home-manager
      firefox
    ];
    shell = pkgs.zsh;
  };

  # use VirtualBox to run VMs for programs that can't run in NixOS (yet), like
  # tuple.
  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "rampion" ];
  # the guest additions package is currently broken:
  #     error: Package ‘VirtualBox-GuestAdditions-6.1.34-5.18.12’ in
  #     /nix/store/4mghfh8bnc42y9nj3b8hnm61v9430zfl-nixos-22.05/nixos/pkgs/applications/virtualization/virtualbox/guest-additions/default.nix:152
  #     is marked as broken, refusing to evaluate.
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.x11 = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    pinentry-gnome # needed by yubikey-agent

    nix-doc # used for looking up documentation
  ];

  # set the $WORDLIST variable to point to a local equivalent to
  # /usr/share/dict/words
  environment.wordlist.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.pcscd.enable = true; # Use the smart card mode (CCID) of yubikey
  services.yubikey-agent.enable = true; # used for SSH agent

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  mercury = {
    # Enable the CA cert used for internal resources
    internalCertificateAuthority.enable = true;

    # Enable services required for MWB development (Postgres)
    mwbDevelopment.enable = true;

    # Enable the internal Nix cache
    nixCache.enable = true;

    # # Create openvpn-mercury.service systemd service
    # # start via `sudo systemctl start openvpn-mercury.service`
    # vpn = {
    #   enable = true;
    #   # pritunl user profile downloaded from https://pritunl.mercury.com/k/1GpKNv597lPEKZTf
    #   configurationPath = toString ./config.ovpn;
    # };
  };

  # VPN tool; not all mercury services are available yet
  # (use pritunl for others)
  services.tailscale.enable = true;

  # Clear up a warning after installing tailscale:
  # 
  #   trace: warning: Strict reverse path filtering breaks Tailscale exit node
  #   use and some subnet routing setups. Consider setting
  #   `networking.firewall.checkReversePath` = 'loose'
  networking.firewall.checkReversePath = "loose";

  # add mercury's CA to the trust store for things like VPNs
  # (added to /etc/pki/tls/certs/ca-bundle.crt)
  security.pki.certificateFiles = [(builtins.toFile "internal.mercury.com.ca.crt" ''
internal.mercury.com
-----BEGIN CERTIFICATE-----
MIIDUDCCAjigAwIBAgIJAOPnjalJGnpNMA0GCSqGSIb3DQEBCwUAMB8xHTAbBgNV
BAMMFGludGVybmFsLm1lcmN1cnkuY29tMB4XDTIwMDIxOTAyMDg1NVoXDTMwMDIx
NjAyMDg1NVowHzEdMBsGA1UEAwwUaW50ZXJuYWwubWVyY3VyeS5jb20wggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCsSdAVzYQsZWO3FVhl/nIXwNnqrrUB
hpkfBrCKspf+rRRrSf9/3G6i9enSAHSs8/HAQjUPNT+5367IfybgbFINZl2QLtyb
QFOWe+ADskG8d1S5wVd7FhgefY+UACHd5mWG8SsAjUxO5Un6RWbVl5z3hILtxVHx
UUGepepYVWukAoz77dYqkVM9ymy3XSxsg7CXrSbPEAIVNRxTMF2ADL/ZqSYA1A3w
Pb55k62U7+rnOe8SbBdpS18z+koCthjaX/cWRvJ2Sg7K3BqURtVKq3GJRJPENGdc
1nvKsH5UYCh5W641BLx89SHXFShH+pev5p7V5VX6TIrTDeq1WK2CJ1DDAgMBAAGj
gY4wgYswHQYDVR0OBBYEFMxJZhpAC5Wh464DErgVtJla5pazME8GA1UdIwRIMEaA
FMxJZhpAC5Wh464DErgVtJla5pazoSOkITAfMR0wGwYDVQQDDBRpbnRlcm5hbC5t
ZXJjdXJ5LmNvbYIJAOPnjalJGnpNMAwGA1UdEwQFMAMBAf8wCwYDVR0PBAQDAgEG
MA0GCSqGSIb3DQEBCwUAA4IBAQANVp9pjCnUyDABXrBtQGYf8p3Z13/ZvGJjvd0o
ParXJ42kYkZvwjUjvOw4/vWtlLOx0uum6ldep1+kFVgLNFxiJ1ogbo8K8MWhel5j
gmDNMX8ccFhWTccgXTpag3zv71bSbbEXRw0PnauyBoE2vTMCKg68LSsNaCmwRix9
1UbJi9qhRxBZtjd0LqdX2o2tKRtWmiMJeLH2ZytqZY60EMNYwpOFAy7edE1+ZpZn
IgWF3vBzHhQZta3BqAUg8F9OOjNj/aZ3eEA7XTbxGFrOn7MCrqKzNWqHfjunThBX
NxZEHtlSSfOTziaZDi182WAMEBW6Ob2icKB/FW7gfgOpCVc3
-----END CERTIFICATE-----
'')];
}
