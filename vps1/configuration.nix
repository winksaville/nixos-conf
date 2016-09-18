# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  if0 = "enp0s15";
  if0_ipv4 = "149.56.41.68";
  if0_ipv4_prefixLength = 32;
  gw = "158.69.227.254";
  harddisk = "/dev/vda";
  host = "vps1";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda";

  swapDevices = [
    {
      device = "/swapfile";
      size = 2000;
    }
  ];


  networking.interfaces.enp0s15.ip4 = [
    {
      address = "${if0_ipv4}";
      prefixLength = if0_ipv4_prefixLength;
    }
  ];
  networking.defaultGateway = "${gw}";
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  networking.hostName = "${host}";
  networking.localCommands =
    ''
      ip route add ${gw} dev ${if0}
      ip route add default via ${gw} dev ${if0}
    '';


  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages = with pkgs; [
  #   wget
  # ];

  # List services that you want to enable:

  services.nixosManual.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraUsers.wink = {
    name = "wink";
    description = "Wink Saville";
    group = "users";
    extraGroups = [ "wheel" ];
    uid = 1000;
    createHome = true;
    home = "/home/wink";
    shell = "/run/current-system/sw/bin/bash";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

  environment.systemPackages = with pkgs; [
    which # clang
  ];
}
