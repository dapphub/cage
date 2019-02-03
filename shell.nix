{ pkgs ? import <nixpkgs> {} }:

with pkgs;
  stdenv.mkDerivation {
  name = "orgdapp-shell";
  buildInputs =
  let orgdapp = (import ./default.nix).orgdapp;
    in
  [ orgdapp ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${toString <nixpkgs>}"
    export LD_LIBRARY_PATH="${libvirt}/lib:$LD_LIBRARY_PATH"
  '';
  }
