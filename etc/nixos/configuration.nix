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
  #boot.kernelParams = ["acpi_backlight=native"];
  
  #Display Manager
 # services.displayManager.sddm.enable = true;
  services.xserver.enable = true; 
  #Hostname
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  hardware.bluetooth.enable =true;
  #Virtualization
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;  # enable copy and paste between host and guest
  virtualisation.spiceUSBRedirection.enable = true; 
  virtualisation.waydroid.enable = true;
  #Tablet
  hardware.opentabletdriver.enable = true;
  # GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [libglvnd libvdpau-va-gl];
};
environment.variables.VDPAU_DRIVER = "va_gl";
environment.variables.LIBVA_DRIVER_NAME = "intel"; 
     			services.xserver.videoDrivers = [ "modesetting" ]; 
			hardware = {
  
     				nvidia = { 
					open = false;
					powerManagement.enable = false;
					package = config.boot.kernelPackages.nvidiaPackages.stable; 
  					powerManagement.finegrained = false;	
     					modesetting.enable = true;# nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway 
  
     					prime = { 
      				 		offload = {
							enable = true;
							enableOffloadCmd = true;
						};
						nvidiaBusId = "PCI:1:0:0";# Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA 
      				 		intelBusId = "PCI:0:2:0"; 
     					};
  				};
			};
	 
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  nixpkgs.config = {
	packageOverrides = pkgs: {
	unstable = import <unstable> {};
	nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      				inherit pkgs;
			};
		};
	};
powerManagement.powertop.enable = true; 
programs.vim = {	
	enable = true;
	defaultEditor = true;
};
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    fcitx5.waylandFrontend = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-unikey ];
  };
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.irisu = {
    isNormalUser = true;
    description = "irisu";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "adbusers" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowUnsupportedSystem = true;
#enable sound with pipewire
security.rtkit.enable = true;
services.pipewire = {
 enable = true;
 alsa.enable = true;
 alsa.support32Bit = true;
 pulse.enable = true;
 jack.enable = true;
};
  fonts.packages = with pkgs; [
	noto-fonts
	noto-fonts-cjk-sans
	noto-fonts-emoji
	nerdfonts
	fira-code
	fira-code-symbols
	font-awesome
        jetbrains-mono
];
  programs.nix-ld.enable = true;
  programs.adb.enable = true;
  programs.nix-ld.libraries = with pkgs; [

    # Add any missing dynamic libraries for unpackaged programs

    # here, NOT in environment.systemPackages
	glibc
	cmake
	gdb
	libgcc
	libclang
	clang-tools
	libstdcxx5
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    python3            # The Python interpreter
    python3Packages.pip # Optional: Package installer
    python3Packages.virtualenv
    nur.repos.ataraxiasjel.waydroid-script 
    home-manager
    scrcpy
    glib
    vscode 
    vim
    wget
    nitch
    git
    ranger
    gdb
    gcc
    fastfetch
    brightnessctl
    firefox
    vesktop
    qtscrcpy
    ani-cli
    mpv 
    cmus
    htop
    networkmanagerapplet
    obsidian
    zip
    unzip
    p7zip
    ueberzugpp
    gitui
    zoom-us
    obs-studio
    microsoft-edge
    obs-studio-plugins.wlrobs
    cava
    cbonsai
    usbutils
    cmatrix
    eog
    atool
    pavucontrol
    spicetify-cli
	jq
	libsForQt5.qtstyleplugin-kvantum
	libsForQt5.qt5ct 
	swappy
	gtk2
	gtk3
	gtk4
	waybar
	dunst
	libnotify
	swww
	alacritty
  kitty
	rofi-wayland
	cliphist
	swaylock
	imagemagick
	grim
	slurp
	wl-clipboard
	wlroots
krita	
gnome-software
  ];
services.flatpak.enable = true;
nixpkgs.config.qt5 = {
  enable = true;
  platformTheme = "qt5ct"; 
    style = {
      package = pkgs.utterly-nord-plasma;
      name = "Utterly Nord Plasma";
    };
};
environment.variables.QT_QPA_PLATFORMTHEME = "qt5ct";
#services.xserver.digimend.enable = true;
services.xserver.excludePackages = with pkgs; [nano xterm];
services.supergfxd.enable = true;
systemd.services.supergfxd.path = [ pkgs.pciutils ];
services.blueman.enable = true;
services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
};

programs.file-roller.enable = true;
programs.fish.enable = true;
users.defaultUserShell = pkgs.fish;
programs.thunar.enable = true;
programs.xfconf.enable = true;
programs.thunar.plugins = with pkgs.xfce; [
  thunar-archive-plugin
  thunar-volman
];
services.gvfs.enable = true; # Mount, trash, and other functionalities
services.tumbler.enable = true; # Thumbnail support for images

#enable Hyprland
xdg.portal.enable = true;
xdg.portal.extraPortals  = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
programs.hyprland = {
	enable = true;
	xwayland.enable = true;
};
environment.sessionVariables = {
	#WLR_NO_HARDWARE_CURSORS ="1";
	NIXOS_OZONE_WL = "1";
};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
