# /etc/nixos/modules/security-tools.nix
# Security research, RE, and pentesting tools
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    radare2
    rizin
    binwalk
    xxd
    
    # === Debuggers ===
    gdb
    pwndbg
    rr
    
    capstone
    keystone
    patchelf
    elfutils
    
    # === Network ===
    nmap
    wireshark
    tcpdump
    netcat-openbsd
    socat
    aircrack-ng
    
    curl
    
    # theharvester  # check availability
    whois
    dnsutils
    
    binwalk
    
    # === Python security libs ===
    python3Packages.pwntools
    python3Packages.scapy
    python3Packages.requests
    python3Packages.beautifulsoup4
    python3Packages.cryptography
    python3Packages.pycryptodome
    python3Packages.z3-solver
    
  ];

  # Wireshark permissions
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

}
