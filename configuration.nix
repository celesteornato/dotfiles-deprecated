{ config, lib, pkgs, ... }:

{
  imports =
  [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Set refresh rate to 60Hz at bootup to counter a manufacturing defect on my screen
  boot.kernelParams = [
    "drm.edid_firmware=eDP-1:edid/1920x1080.bin"
  ];
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;


  # Setup Locale
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.supportedLocales = [
      "en_GB.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LANGUAGE = "en_GB.UTF-8";
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
    LANG = "en_GB.UTF-8";
  };
  console.keyMap = "fr";

  services = {
      printing = {
        enable = true;
        allowFrom = [ "all" ];
        browsing = true;
        defaultShared = true;
        openFirewall = true;
        #drivers = [pkgs.hplipWithPlugin];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };

      # Bluetooth
      blueman.enable = true;

      # Sound
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # Touchpad
      libinput.enable = true;

      xserver = {
        videoDrivers = ["nvidia"];
        enable = true;
        displayManager.startx.enable = true;
        xkb.layout = "fr";
        xkb.variant = "";
      };

      openssh.enable = true;
      earlyoom.enable = true;
  };

  hardware = {

    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio.enable = false;
    # SANE
    sane = {
      enable = true;
#      extraBackends = [ pkgs.hplipWithPlugin ];
    };

    # NVIDIA
    graphics = {
      enable = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

  };

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;

  users.groups.video = {};
  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  users.users.main = {
    isNormalUser = true;
    description = "Main";
    extraGroups = [ "networkmanager" "wheel" "video" "scanner" "lp"];
    shell = pkgs.fish;
    packages = with pkgs; [
      firefox
      librewolf
    ];
  };


  environment.systemPackages = with pkgs; [
    (import ./scripts/wallswap.nix {inherit pkgs; })
    (import ./scripts/rebuild.nix {inherit pkgs; })
    (import ./scripts/prime-run.nix {inherit pkgs; })
    (import ./scripts/update.nix {inherit pkgs; })
    (import ./scripts/scan.nix {inherit pkgs; })
    vim
    neovim
    wget
    git
    swaybg
    sway
    kitty
    fish
    pulseaudio
    fastfetch
    stable.grim
    stable.grimblast
    stable.slurp
    stable.wl-clipboard
    mako
    rofi
    vesktop
    prism
    prismlauncher
    tuir
    ytfzf
    steam
    oh-my-fish
    wineWowPackages.waylandFull
    winetricks
    htop
    btop
    blueman
    gcc
    gpp
    rustup
    cargo
    rustc
    rust-analyzer
    rustfmt
    cmake
    gnumake
    ninja
    zig
   #stable.hplip
    hyfetch
    xfce.thunar
    tmux
    pywal
    gamemode
    mangohud
    nvtopPackages.full
    lshw
    godot_4
    iw
    waybar
    brightnessctl
    vitetris
    tectonic
    kalker
    opera
    mpv
    feh
    transmission_4
    earlyoom
    unzip
    obs-studio
    stable.trenchbroom
    stable.audacity
    gimp
    krita
    wl-gammactl
    ncpamixer
    p7zip
    
    # Some libraries are required for Lutris to work correctly
    libunwind
    lutris

  ];
  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
  programs.sway = {
    enable = true; 
    wrapperFeatures.gtk=true;
  };
  environment.etc."sway/config".source = ./sway/config;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true; 
  };

  # Setup NIX
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };


  nixpkgs.config.allowUnfree = true;

  networking.firewall.enable = false;


  system.stateVersion = "23.11"; # Did you read the comment?

}
