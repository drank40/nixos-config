# /etc/nixos/modules/development.nix
# Rust, cross-compilation, and general dev tools
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # === Rust ===
    rustup
    rust-analyzer
    cargo-watch
    cargo-edit
    cargo-audit
    cargo-outdated
    
    # === C/C++ ===
    gcc
    clang
    llvm
    lld
    ccache
    universal-ctags
    cmake
    ninja
    meson
    autoconf
    automake
    libtool
    pkg-config
    bear   
    
    # === Cross compilation (ARM) ===
    pkgsCross.aarch64-multiplatform.buildPackages.gcc
    pkgsCross.armv7l-hf-multiplatform.buildPackages.gcc
    qemu
    
    # === Embedded / AVR ===
    avrdude
    pkgsCross.avr.buildPackages.gcc
    arduino-cli   
   
    # === Python ===
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.ipython
    python3Packages.pytest
    python3Packages.black
    python3Packages.pylint
    pyright  # LSP
    uv       # fast pip/venv
    
    # === Node.js / JS/TS ===
    nodejs
    yarn
    nodePackages.npm
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.eslint
    
    # === Build / CI ===
    gnumake
    
    # === Debugging / profiling ===
    gdb
    lldb
    linuxPackages.perf
    
    protobuf
  ];
}
