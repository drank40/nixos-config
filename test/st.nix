{ pkgs ? import <nixpkgs> {} }:

pkgs.st.overrideAttrs (old: {
src = pkgs.fetchFromGitHub {
  owner = "drank40";       # <-- change this
  repo = "st";
  rev = "ce6df34";
  sha256 = "sha256-h3k5ot5KfN9hn7mVwHfWWwKYQDe4d0eMrxeneA1r9vE=";
};
nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.git ];
buildInputs = old.buildInputs ++ [ pkgs.harfbuzz ];
})
