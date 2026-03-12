{
  enableGUI = true;        # false for headless servers (Hetzner)
  enableBluetooth = true;  # false for servers
  hostname = "nsa-router";     # change per machine
  username = "renny";       # your username
  oldPkgs = builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/9c48b89b70a53ba783fc0549abb8c322ed2d3298.tar.gz";
      sha256 = "sha256:0103a1a1g5sp4bjhm6fl0nfw69jgdiwrwz96nnqi0f3bg6vcg1sf";

    };
}

