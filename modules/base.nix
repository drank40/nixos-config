# /etc/nixos/modules/base.nix
# Core system packages and configuration
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core utils
    coreutils
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
    fastfetch

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

    # Python base
    python3
    python3Packages.pip
    python3Packages.virtualenv

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
    liberation_ttf
    fira-code
    fira-code-symbols
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.hack
  ];

  # Enable man pages
  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };
}
