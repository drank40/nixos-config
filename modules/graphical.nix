# /etc/nixos/modules/graphical.nix
# X11, dwm, custom suckless tools, and GUI applications
{ config, lib, pkgs, unstable, ... }:

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
      libglvnd
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
    XCURSOR_SIZE = 24;
    XCURSOR_THEME = "Adwaita";
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1";
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
          rev = "0902fc20"; 
          sha256 = "sha256-duz+HMcC0Wgv1B2r1+v0Sp1MRUbNBX3NQ8MQ21WQG7o="; 
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
          rev = "2045474";
          sha256 = "sha256-/04jlTezS/xgiSQ42T0fd+HcCFxwT8cas1Of0F0BWEc=";
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
    xorg.libxcb
    xcb-util-cursor

    qt6.full
    libxkbcommon
    libGL
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
    ffmpeg-full
    imagemagick
    gimp
    
    # === Documents ===
    zathura
    libreoffice
    
    # sec  
    wireshark


    # audio
    pulsemixer
    redshift
    xdragon
    zlib
    bluetuith
    unstable.claude-code
    unstable.font-awesome
    kaidan
    arduino-cli
    moserial
    clang-tools
    thunderbird
    openrgb
    playerctl
    httrack
    ghostwriter
    nix-index
    pwntools
    alsa-utils
    pcmanfm
    blender
    freecad
    portaudio
    mumble
    sxiv
    arandr
    unstable.qbittorrent
  ];

  # GTK theming
  programs.dconf.enable = true;
  
  # Enable these for some apps
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # Screen locker
  programs.slock.enable = true;

  home-manager.users.${vars.username} = {

    
    gtk = {
        enable = true;
        theme = {
            name = "Adwaita-dark";
            package = pkgs.adwaita-icon-theme;
        };
    };
    dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
    };

    home.file.".config/libinput-gestures.conf".text = ''
      gesture swipe left 3 xdotool key super+n
      gesture swipe right 3 xdotool key super+b
      gesture swipe down 3 xdotool key super+Tab
      gesture swipe up 3 xdotool key super+z
      gesture swipe right 4 xdotool key alt+Left
      gesture swipe left 4 xdotool key alt+Right
    '';
  };

  # For screen sharing, etc.
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}


