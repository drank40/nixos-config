# /etc/nixos/modules/graphical.nix
# X11, dwm, custom suckless tools, and GUI applications
{ config, lib, pkgs, ... }:

{
  # X11 / Display server
  services.xserver = {
    # Keyboard
    xkb = {
      layout = "it";
    };
    
    # DWM
    windowManager.dwm.enable = true;
    
    # Display manager (minimal)
    displayManager.startx.enable = true;
  };

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
      #st = prev.st.overrideAttrs (old: {
      #  src = pkgs.fetchgit {
      #	  url = "https://github.com/drank40/st";
      #    rev = "ce6df34";
      #    sha256 = "sha256-h3k5ot5KfN9hn7mVwHfWWwKYQDe4d0eMrxeneA1r9vE=";
      #  };
	#nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.git ];
        #buildInputs = old.buildInputs ++ [ pkgs.harfbuzz ];
	#preBuild = "";
	#postPatch = "";
	#buildPhase = '' make '';
      #});

    })
  ];

  environment.systemPackages = with pkgs; [
    dwm
    st
    dmenu
    slock
    slstatus
    
    xorg.xinit
    xorg.xrandr
    xorg.xsetroot
    xorg.xmodmap
    xorg.xev
    xorg.xprop
    xorg.xwininfo
    xclip
    xsel
    xdotool
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

  # For screen sharing, etc.
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}


