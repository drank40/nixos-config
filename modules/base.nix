# /etc/nixos/modules/base.nix
# Core system packages and configuration
{ config, lib, pkgs, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core utils
    amdvlk
    gdu
    libseccomp
    gh
    jdk21
    maven
    unstable.rocksdb
    tmux
    pkgs.pkgsi686Linux.amdvlk
    xreader
    unstable.networkmanagerapplet
    pkgs.glib
    pkgs.zlib
    pkgs.libGL
    pkgs.fontconfig
    pkgs.xorg.libX11
    pkgs.libxkbcommon
    pkgs.freetype
    pkgs.dbus
    ncmpcpp
    mpdris2
    
    gnuplot
    mesa.drivers
    libvdpau-va-gl
    vaapiVdpau
    libglvnd
    vulkan-loader
    vulkan-tools
    hcloud
    mermaid-cli
    ueberzugpp
    imagemagick
    luajitPackages.magick
    google-fonts
    parallel
    just
    typst
    direnv
    coreutils
    bash
    proot
    rlwrap
    mlocate
    findutils
    diffutils
    gnused
    gawk
    gnugrep
    which
    file
    tree
    htop
    btop
    hashcash
    fastfetch
    killall
    screen
    pwntools
    burpsuite
    mullvad-vpn
    xz
    pkg-config
    coc-clangd
    zig
    

    
    android-tools

    (python3.withPackages (ps: with ps; [
      pwntools
      requests
      ipython
      pytest
      black
      pynvim
      docker
      z3-solver
      pip 
      virtualenv
    ]))

    delta

    # Archives
    zip
    unzip
    p7zip
    unrar
    xz
    zstd

    # Networking
    curl
    wget
    socat
    nmap
    whois
    bind  # dig, nslookup
    tcpdump
    wireshark
    wireguard-tools

    # Filesystems
    dosfstools
    exfatprogs
    ntfs3g
    btrfs-progs
    sshfs

    # System tools
    pciutils
    usbutils
    dmidecode
    lsof
    strace
    ltrace
    sysstat

    # Editors & shell
    neovim
    vim
    zsh
    fzf
    zoxide
    ripgrep
    fd

    # Git
    git
    git-lfs

    # Build essentials
    gnumake
    cmake
    ninja
    pkg-config
    gcc
    clang
    llvm
    binutils

    # Node base
    nodejs
    yarn
    nodePackages.npm

    # Misc
    jq
    yq
    bc
    man-pages
    man-pages-posix
  ];

  # Fonts
  fonts.packages = with pkgs; [
    dejavu_fonts
    iosevka
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    jetbrains-mono
    noto-fonts
    unstable.font-awesome
    noto-fonts-color-emoji
  ];

  # Enable man pages
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };
}
