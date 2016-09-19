# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

# New comment line

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "mba1"; # Define your hostname.
    extraHosts = "149.56.41.68 vps1 vps1";
    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
    useDHCP = true;
    wicd.enable = true; 
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # allowUnfree is needed to support broadcom wireless drivers
  nixpkgs.config = {
    allowUnfree = true;
    vim.python = false;
    vim.ruby = false;
    vim.lua = false;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment = {
    systemPackages =
      with pkgs; [
        re2c texinfo gperf help2man flex
        tree
        chromium
        pciutils
        gitAndTools.gitFull
        clang
        gcc
        gnumake
        python
        python3
        terminator
        keychain
        (vim_configurable.override {
          features = "normal";
          clipboard = true;
          xterm_clipboard = true;
          #python = python3;
        })
        #vim
        wget
        which
        lxappearance
        xclip xlibs.xcursorthemes xlibs.xev xlibs.xmodmap
        xlibs.xset xlibs.xbacklight
      ];
  };

  # List services that you want to enable:

  # nixosManu is by default true, uncomment if an error.
  # I saw an error on pacmanvps with a 512M machine an no
  # swap partition/file.

  # Enable acpi

  services.acpid.enable = true;
  services.acpid.lidEventCommands = ''
    LID_STATE=/proc/acpi/button/lid/LID0/state
    if [ $(/run/current-system/sw/bin/awk '{print $2}' $LID_STATE) = 'closed' ]; then
      systemctl suspend
    fi
  '';
    
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Configure fonts
  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = [
      pkgs.terminus_font
      pkgs.ubuntu_font_family
      pkgs.dejavu_fonts
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";

    displayManager = {
      lightdm.enable = true;
      #lightdm.defaultUser = "wink";
    };

    desktopManager = {
      xterm.enable = false;
      default = "none";
      #xfce.enable = true;
      #default = "xfce";
    };

    windowManager = {
      default = "i3";
      i3.enable = true;
      #xmonad.enable = true;
      #twm.enable = true;
      #icewm.enable = true;
    };

    synaptics = {
      enable = true;
      buttonsMap = [ 1 3 2 ];
      tapButtons = true;
      twoFingerScroll = true;
      vertEdgeScroll = false;
      minSpeed = "0.6";
      maxSpeed = "60";
      accelFactor = "0.0075";
      palmDetect = true;
      additionalOptions = ''
        Option "VertScrollDelta" "-130"
        Option "HorizScrollDelta" "-130"
        Option "FingerLow" "40"
        Option "FingerHigh" "60"
      '';

      #xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraUsers.wink = {
    name = "wink";
    description = "Wink Saville";
    group = "users";
    #extraGroups = [ "wheel" "networkmanager" ];
    extraGroups = [ "wheel" ];
    uid = 1000;
    createHome = true;
    home = "/home/wink";
    shell = "/run/current-system/sw/bin/bash";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system = {
    stateVersion = "16.03";
    copySystemConfiguration = true;
  };

}
