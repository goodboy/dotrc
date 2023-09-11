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

  # add i2c-dev module and rules for ddcutil, see answer:
  # https://discourse.nixos.org/t/how-to-enable-ddc-brightness-control-i2c-permissions/20800/9
  # https://github.com/NixOS/nixpkgs/blob/72f492e275fc29d44b3a4daf952fbeffc4aed5b8/nixos/modules/services/x11/desktop-managers/plasma5.nix#L258
  # boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
  boot.kernelModules = [
    "i2c-dev"
    "xt_state"
  ];
  # use `journalctl -f` to ensure no errors!
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';

  # always disable v6 on wifi by default
  boot.kernel.sysctl."net.ipv6.conf.wlp2s0.disable_ipv6" = true;

  networking = {
    hostName = "TinasMacMini"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    enableIPv6  = false;
    # wireless.enable = true;
  };
  # Pick only one of the below networking options.
  # networking  # Enables wireless support via wpa_supplicant.

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 616 ];

    # require public key authentication for better security
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "yes";
    };
  };

  # Open ports in the firewall: {sshd, etc.}
  networking.firewall.allowedTCPPorts = [
    6116 # piker
    24800 # barrier
  ];
  networking.firewall.allowedUDPPorts = [ 
    51820 # wg
  ];
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
  xdg.portal.wlr.enable = true;
  # xdg.portal.lxqt.enable = true;
  # xdg.portal.xdgOpenUsePortal = true;
  # xdg.portal.extraPortals = with pkgs; [
    # xdg-desktop-portal-wlr
    # lxqt.xdg-desktop-portal-lxqt
    # xdg-desktop-portal-gtk
  # ];

  time.timeZone = "America/Toronto";

  virtualisation = {
    docker = {
      enable = true;  # run daemon with systemd
      rootless = {  # no-root mode
        enable = true;
        setSocketVariable = true;
      };
    };
    # https://nixos.wiki/wiki/WayDroid
    waydroid.enable = true;
  };


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    # keyMap = "us";  # already defined in root profile?
    useXkbConfig = true; # use xkbOptions in tty (only reason to use Xorg).
  };

  # Enable the X11 windowing system.
  services.xserver = {
    # autorun = true;
    # enable = true;
    # windowManager.i3.enable = true;

    # TODO: figure out how to just use login + startx
    # displayManager.lightdm.enable = true;
    #displayManager.startx.enable = true;
    #displayManager.defaultSession = "i3";

    # Configure keymap in X11
    layout = "us";
    xkbOptions = "caps:ctrl_modifier, ctrl:nocaps";  # map caps to ctl.
    upscaleDefaultCursor = true;
    dpi = 200;

    # Enable touchpad support (enabled default in most desktopManager).
    # libinput.enable = true;
  };


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # sys-wide config
  users.defaultUserShell = pkgs.bash;
  environment = {

    # use xonsh as sys-wide shell B)
    shells = with pkgs; [ bash ];

    # https://github.com/nix-community/nix-direnv#via-configurationnix-in-nixos
    pathsToLink = [ "/share-nix-direnv" ];
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
      TERMINAL = "alacritty";
      # GTK_USER_PORTAL = "1";
    };

    # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
    # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
    sessionVariables = rec {
      # used by `grimshot`
      XDG_PICTURES_DIR = "$HOME/images/screenshots/";

      # tell element/electron that we're in wayland mode
      NIXOS_OZONE_WL = "1";

      # TODO: figure out which of these breaks xonsh?
      # XDG_CACHE_HOME  = "$HOME/.cache";
      # XDG_CONFIG_HOME = "$HOME/.config";
      # XDG_DATA_HOME   = "$HOME/.local/share";
      # XDG_STATE_HOME  = "$HOME/.local/state";

      # for bins, but location it NOT officially in the spec ;)
      # XDG_BIN_HOME = "$HOME/.local/bin";
      # PATH = [ 
      #   "${XDG_BIN_HOME}"
      # ];

    };

    # packages installed in system profile.
    systemPackages = with pkgs; [
      # nix toolz
      nix-index

      # preferred shell
      xonsh

      # one-vi-to-rule-them-all
      neovim
      helix  # rust, selection oriented

      # utils
      wget
      nftables

      # need root for managing network
      nm-tray
      # the OG applet in GTK (doesn't work w wayland ootb)
      networkmanagerapplet

      # file xfer
      magic-wormhole

      # must have for wayland for link opening via xdg-open
      xdg-utils

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
    extraGroups = [
      "wheel"  # ‘sudo’ group
      # "video"  # `ddcutil` group(s)?
      "i2c-dev"
      # "networkmanager"  # allow using sysctl?
      "docker"  # using cmds without sudo
      "adbusers"  # android debug
    ];
    packages = with pkgs; [

      # DE shite
      # X11
      i3  # wm
      i3status  # status bar (sway too)
      i3lock
      maim  # screenshotz  (X only?)
      # dmenu
      # i3status-rust  # status bar (sway too)

      # Wayland (+ sway)
      # cooio wl launcher recos
      # https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway#launchers
      kickoff
      sway-contrib.grimshot

      xclip  # X11-copy/pasta
      wl-clipboard  # wayland-copy-pasta (FYI: needs nvim config)

      # display ctls
      arandr  # multi-mon config via GUI B)
      ddcutil  # display ctl prot

      # media
      quodlibet  # audio player
      pavucontrol
      obs-studio  # media-recording
      mpv

      firefox  #  web-browser
      # TODO: once we get `vopono` working fully, muck around
      # with some alt privacy/opsec focussed browsers?
      # - apparently best soln is some arkenfox.js extension from
      #   tor community?
      #  - https://www.unixsheikh.com/articles/choose-your-browser-carefully.html#tweaking-firefox
      #  - https://github.com/arkenfox/user.js
      # - why librewolf isn't sufficient:
      #   https://www.unixsheikh.com/articles/choose-your-browser-carefully.html#librewolf
      # libre-wolf  # oh it's in the ol nixpkgs!

      # apps?
      appimage-run

      # matrix
      # gomuk  # hackin on this rite now tho..
      # element-desktop  # X11

      # NOTE: should pass the following flags but doesn't seem to?
      # --enable-features=UseOzonePlatform --ozone-platform=wayland
      # https://github.com/NixOS/nixpkgs/pull/132776/files
      element-desktop-wayland

      # terminal related
      alacritty
      tmux

      # python310Packages.prompt-toolkit  # wenn
      # xonsh
      neovim
      ranger  # deps on w3m for image view on X11
      # feh  # wrap with ranger for images?
      imv  # currently using shit ass ranger integ..

      # git + hosting service utils
      git
      github-cli
      glab

      # sh utils
      htop
      ncdu
      tree
      mlocate

      # networkin (mgmt) toolz
      httpie
      mtr
      nmap
      vopono  # can't belieb they have this B)
      wireguard-tools

      # NOTE: we have to setup a TLS key on both client and server:
      # normally, ~/.local/share/barrier/SSL/
      # TODO: automate this using flake deployment tech?
      # https://stackoverflow.com/a/67343805
      # barrier
      input-leap

      # utils + docs
      man-pages
      translate-shell  # spoken langs

      # style
      hack-font
      hackgen-nf-font

      # langs + runtimes
      python310
      poetry  # borked rn?
      ruff
      # python310Packages.python-lsp-ruff
      python310Packages.python-lsp-server

      python311
      python311Packages.pdftotext  # for pdfs in nvim
      # python311Packages.python-lsp-ruff
      python311Packages.python-lsp-server
      # python311Packages.xonsh  # wenn
      # python311Packages.poetry-core
      # pip never again !? XD

      # opsec
      age

      # storage/backups
      borgbackup

      # mobile
      waydroid

    ];
  };

  # enable sway window manager
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    # programs.bash.enable = true;
    # programs.xonsh.enable = true;
    # programs.zsh.enable = true;
    bash.enableCompletion = true;
    # programs.dconf.enable = true;

    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    adb.enable = true;
  };

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
