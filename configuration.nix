# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Set refresh rate to 60Hz at bootup to counter a manufacturing defect on my screen
  boot.kernelParams = [
    "drm.edid_firmware=eDP-1:edid/1920x1080.bin"
  ];
  
  # NIXOS
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "nixos"; # Define your hostname.

  # nvidia
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  
  hardware.nvidia.prime = {
		offload = {
			enable = true;
			enableOffloadCmd = true;
		};
		# Make sure to use the correct Bus ID values for your system!
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:1:0:0";
	};
 
  


  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
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

  # Configure console keymap
  console.keyMap = "fr";

  services = {
      # Cups does not seem to work but you never know
      printing = {
        enable = true;
        allowFrom = [ "all" ];
        browsing = true;
        defaultShared = true;
        openFirewall = true;
        drivers = [pkgs.hplipWithPlugin];
      };
      avahi = {
        enable = true;
        nssmdns = true;
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
      xserver.libinput.enable = true;

      xserver = {
        videoDrivers = ["nvidia"];
        enable = true;
        displayManager.startx.enable = true;
        layout = "fr";
        xkbVariant = "";
      };

      openssh.enable = true;
  };
  
  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.main = {
    isNormalUser = true;
    description = "Main";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      librewolf
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
    fastfetch
    kitty
    sway
    swaybg
    grim
    slurp
    wl-clipboard
    mako
    rofi
    vesktop
    prism
    prismlauncher
    fish
    tuir
    ytfzf
    steam
    oh-my-fish
    wine
    winetricks
    htop
    btop
    blueman
    neovim
    gcc
    rustup
    zig
    hplip
    hyfetch
    xfce.thunar
    pulseaudio
    tmux
    pywal
    gamemode
    mangohud
    nvtop
    lshw
    godot_4
    iw
    (import ./scripts/wallswap.nix {inherit pkgs; })
    (import ./scripts/rebuild.nix {inherit pkgs; })
    (import ./scripts/prime-run.nix {inherit pkgs; })
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
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ 5353 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
