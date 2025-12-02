# Example dev shell for Solana/Rust project
# Usage: nix-shell or `nix develop` (with flakes)
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "solana-dev";
  
  buildInputs = with pkgs; [
    # Rust
    rustup
    rust-analyzer
    cargo-watch
    cargo-edit
    
    # Solana
    solana-cli
    # anchor via: cargo install --git https://github.com/coral-xyz/anchor anchor-cli
    
    # Build deps
    pkg-config
    openssl
    libudev-zero
    
    # Utils
    jq
    git
  ];

  # For Solana BPF
  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  
  shellHook = ''
    echo "Solana dev shell"
    echo "Solana: $(solana --version 2>/dev/null || echo 'not in PATH')"
    echo "Rust: $(rustc --version 2>/dev/null || echo 'run: rustup default stable')"
  '';
}
