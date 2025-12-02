# /etc/nixos/modules/blockchain.nix
# Ethereum, Solana, and blockchain development tools
{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # === Ethereum ===
    solc 
    
  ];
}
