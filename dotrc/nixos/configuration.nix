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

  networking = {
    hostName = "TinasMacbookAir"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  };
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    #keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    autorun = true;

    # TODO: figure out how to just use login + startx
    displayManager.lightdm.enable = true;
    #displayManager.startx.enable = true;
    #displayManager.defaultSession = "i3";
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:ctrl_modifier, ctrl:nocaps";  # map caps to ctl.
  services.xserver.upscaleDefaultCursor = true;
  services.xserver.dpi = 200;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # sys-wide config
  users.defaultUserShell = pkgs.xonsh;
  environment = {

    # use xonsh as sys-wide shell B)
    shells = with pkgs; [ xonsh ];

    # https://github.com/nix-community/nix-direnv#via-configurationnix-in-nixos
    pathsToLink = [ "/share-nix-direnv" ];
    variables = {
      EDITOR = "neovim";
      VISUAL = "neovim";
      PAGER = "less";
      TERMINAL = "alacritty";
    };

    # packages installed in system profile.
      systemPackages = with pkgs; [
      direnv
      nix-direnv
      neovim
      wget
    ];
  };
  nixpkgs.overlays = [
  (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; } )
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lord_fomo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];  # Enable ‘sudo’ for the user.
    packages = with pkgs; [

      # GUI shite
      xclip  # X-copy/pasta
      firefox  #  web-browser
      i3  # wm
      maim  # screenshotz
      obs-studio  # media-recording
      quodlibet  # audio player
      pavucontrol

      # matrix
      # gomuks  
      # element-desktop

      # terminal related
      alacritty
      xonsh
      neovim
      ranger

      # git + hosting service utils
      git
      github-cli
      glab


      # sh utils
      htop
      mtr
      ncdu
      tree
      mlocate

      # utils + docs
      man-pages
      translate-shell  # spoken langs

      # style
      hack-font

      # langs & runtimes
      #pip
      python310
      python311

      go

      # network
      barrier
      openssl

    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.xonsh.enable = true;
  programs.bash.enableCompletion = true;
  programs.dconf.enable = true;

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 24800 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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
