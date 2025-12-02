# /etc/nixos/modules/graphical.nix
# X11, dwm, custom suckless tools, and GUI applications
{ config, lib, pkgs, ... }:

let 
  vars = import ../vars.nix;
in
{


  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  # X11 / Display server
  services.xserver = {
    enable = true;

    videoDrivers = [ "amdgpu" ];
    # Keyboard

    dpi = 144;

    xkb = {
      layout = "it";
    };

    modules = with pkgs.xorg; [
	xf86inputlibinput
	xf86videoamdgpu
    ];

    
    # DWM
    windowManager.dwm.enable = true;
    
    # Display manager (minimal)
    displayManager.startx.enable = true;

    deviceSection = ''
      Option "TearFree" "true"
    '';

    serverFlagsSection = ''
      Option "AutoAddDevices" "true"
    '';

    filesSection = ''
	ModulePath "${pkgs.xorg.xf86inputlibinput}/lib/xorg/modules/input"
	ModulePath "${pkgs.xorg.xf86videoamdgpu}/lib/xorg/modules/drivers"
	ModulePath "${pkgs.xorg.xorgserver}/lib/xorg/modules"
	ModulePath "${pkgs.xorg.xorgserver}/lib/xorg/modules/extensions"
    '';

  };

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;  
      clickMethod = "clickfinger";  # or "buttonareas"
    };
  };

  environment.variables = {
    XCURSOR_SIZE = 128;
    XCURSOR_THEME = "Adwaita";
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
    Xft.dpi: 144
    EOF
  '';

  nixpkgs.overlays = [
    (final: prev: {
      # Custom dwm
      dwm = prev.dwm.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner = "drank40"; 
          repo = "dwm-custom";
          rev = "2fe254e"; 
          sha256 = "sha256-F1CMhRdOGz0+0qT8YCdMMz+7s08F/mgiOrwIJMJQIbc="; 
       };
       buildInputs = old.buildInputs ++ [ 
         pkgs.xorg.libXinerama
	 pkgs.xorg.libXinerama.dev
       ];
      });

      # Custom st
      st = prev.st.overrideAttrs (old: {
        src = pkgs.fetchgit {
      	  url = "https://github.com/drank40/st";
          rev = "f53f175";
          sha256 = "sha256-CsIXI4hS+XU0RRIkss8d8xGayLDRq5hbdW6oDnyC1Zg=";
        };

	#env vars
	FONT_SIZE = "28";

	nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.git ];
        buildInputs = old.buildInputs ++ [ pkgs.harfbuzz ];
	#preBuild = "";
	#postPatch = "";
	buildPhase = ''make'';
	installPhase = '' 
	  runHook preInstall
	  TERMINFO=$out/share/terminfo make clean install PREFIX=$out
	  runHook postInstall
	'';
      });

    })
  ];

  environment.systemPackages = with pkgs; [
    dwm
    st
    dmenu
    slock
    slstatus
    libinput
    picom
    inter
    adwaita-icon-theme
    imlib2
    libinput-gestures
    wmctrl

    xorg.setxkbmap   
    xorg.xinit
    xorg.xinput
    xorg.xrandr
    xorg.xsetroot
    xorg.xmodmap
    xorg.xev
    xorg.xprop
    xorg.xwininfo
    xclip
    xsel
    xdotool
    xorg.xauth
    xautolock
    autocutsel
    picom   
    feh    # wallpaper / image viewer
    scrot  


    # files
    lf
    
    
    # === Browsers ===
    brave
    
    # === Communication ===
    discord
    slack
    telegram-desktop
    
    # === Media ===
    mpv
    ffmpeg
    imagemagick
    gimp
    
    # === Documents ===
    zathura
    libreoffice
    
    # sec  
    ghidra
    wireshark
  ];

  # GTK theming
  programs.dconf.enable = true;
  
  # Enable these for some apps
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # Screen locker
  programs.slock.enable = true;

  home-manager.users.${vars.username} = {
    home.file.".config/libinput-gestures.conf".text = ''
      gesture swipe left 3 xdotool key super+b
      gesture swipe right 3 xdotool key super+n
    '';
  };

  # For screen sharing, etc.
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}


