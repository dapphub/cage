{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let act_mode = stdenv.mkDerivation {
  name = "act-mode";
  src = fetchFromGitHub {
    owner  = "livnev";
    repo   = "act-mode";
    rev    = "ff65a89d9dbb40cb8e5c02c642b655ed5dbe4f50";
    sha256 = "138rpwppwyiaw7c2367ll3m2x9hqj03z8r5c60j6gzspp3ywqq8i";
  };
  installPhase = ''
    mkdir -p $out/share/emacs/site-lisp
    install *.el* $out/share/emacs/site-lisp
  '';
};
in
  stdenv.mkDerivation {
  name = "orgdapp";
  buildInputs =
  let emacs = emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
      act_mode
      htmlize
      projectile
      solarized-theme
    ]));
      in [ emacs ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${toString <nixpkgs>}"
    export LD_LIBRARY_PATH="${libvirt}/lib:$LD_LIBRARY_PATH"
  '';
  installPhase = "mkdir $out/bin && install bin/* $out/bin";
}
