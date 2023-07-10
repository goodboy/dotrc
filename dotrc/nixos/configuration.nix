# vim: set et sw=2
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # use latest kernel release
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "TinasMacbookAir"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    # wireless.enable = true;
  };
  # Pick only one of the below networking options.
  # networking  # Enables wireless support via wpa_supplicant.

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # require public key authentication for better security
    passwordAuthentication = false;
    kbdInteractiveAuthentication = false;
    ports = [ 616 ];
    #PermitRootLogin = "yes";
  };

  # Open ports in the firewall: {sshd, etc.}
  networking.firewall.allowedTCPPorts = [ 6116 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # rtkit is optional but recommended
  security.rtkit.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # use pipewire instead of pulse B)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.lxqt.enable = true;
  # xdg.portal.xdgOpenUsePortal = true;
  # xdg.portal.extraPortals = with pkgs; [
    # xdg-desktop-portal-wlr
    # lxqt.xdg-desktop-portal-lxqt
    # xdg-desktop-portal-gtk
  # ];

  # Set your time zone.
  time.timeZone = "America/Toronto";

  virtualisation.docker.rootless = {
    enable = false;
    setSocketVariable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    # keyMap = "us";  # already defined in root profile?
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    windowManager.i3.enable = true;

    # TODO: figure out how to just use login + startx
    displayManager.lightdm.enable = true;
    #displayManager.startx.enable = true;
    #displayManager.defaultSession = "i3";

    # Configure keymap in X11
    layout = "us";
    xkbOptions = "caps:ctrl_modifier, ctrl:nocaps";  # map caps to ctl.
    upscaleDefaultCursor = true;
    dpi = 200;
  };


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # sys-wide config
  users.defaultUserShell = pkgs.bash;
  environment = {

    # use xonsh as sys-wide shell B)
    shells = with pkgs; [ bash ];

    # https://github.com/nix-community/nix-direnv#via-configurationnix-in-nixos
    pathsToLink = [ "/share-nix-direnv" ];
    variables = {
      EDITOR = "neovim";
      VISUAL = "neovim";
      PAGER = "less";
      TERMINAL = "alacritty";
      # GTK_USER_PORTAL = "1";
    };

    # packages installed in system profile.
    systemPackages = with pkgs; [
      xonsh

      # one-vi-to-rule-them-all
      neovim

      # utils
      wget

      # need root for managing network
      # nm-tray
      networkmanagerapplet  # the OG applet in GTK

      # xdg-desktop-portal
      # lxqt.xdg-desktop-portal-lxqt
      # xdg-desktop-portal-wlr
      # xdg-desktop-portal-gtk

      # development on nixos
      direnv
      nix-direnv

    ];
  };
  nixpkgs.overlays = [
    (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lord_fomo = {

    # https://nixos.wiki/wiki/SSH_public_key_authentication
    # content of authorized_keys file
    # note: ssh-copy-id will add user@clientmachine after the public key
    # but we can remove the "@clientmachine" part
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP98WAal3hMzZnIHGDoksEXW+WHWHkrd1JKFyPYg8dEZ lord_fomo" # goodboy@TinasMacbookAir"
    ];


    isNormalUser = true;
    extraGroups = [ "wheel" ];  # Enable ‘sudo’ for the user.
    packages = with pkgs; [

      # DE shite
      i3  # wm
      xclip  # X-copy/pasta
      arandr  # multi-mon config via GUI B)

      # media
      maim  # screenshotz
      quodlibet  # audio player
      pavucontrol
      obs-studio  # media-recording
      mpv

      firefox  #  web-browser
      # xdg-desktop-portal
      # lxqt.xdg-desktop-portal-lxqt
      # xdg-desktop-portal-wlr
      # xdg-desktop-portal-gtk

      # matrix
      # gomuk  # hackin on this rite now tho..
      element-desktop

      # terminal related
      alacritty
      # python310Packages.prompt-toolkit  # wenn
      # xonsh
      neovim
      ranger

      # git + hosting service utils
      git
      github-cli
      glab

      # sh utils
      htop
      ncdu
      tree
      mlocate

      # networkin toolz
      httpie
      mtr
      nmap

      # utils + docs
      man-pages
      translate-shell  # spoken langs

      # style
      hack-font
      hackgen-nf-font

      # langs & runtimes
      # pip never again !? XD
      python310
      # poetry  # borked rn?
      ruff

      python311
      python311Packages.pdftotext  # for pdfs in nvim
      # python311Packages.xonsh  # wenn
      # python311Packages.poetry-core

      # go

      # network (mgmt) tools
      # barrier
      # openssl

      # storage
      borgbackup

    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  # programs.bash.enable = true;
  # programs.xonsh.enable = true;
  # programs.zsh.enable = true;
  programs.bash.enableCompletion = true;
  # programs.dconf.enable = true;

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  # enable ng CLI and the flakes stuff B)
  nix.settings = {
    # enable flakes and nix-direnv:
    # https://github.com/nix-community/nix-direnv#via-configurationnix-in-nixos
    keep-outputs = true;
    keep-derivations = true;
    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

}
